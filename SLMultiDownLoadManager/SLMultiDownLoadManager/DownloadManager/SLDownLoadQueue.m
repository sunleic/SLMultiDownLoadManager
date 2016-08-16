//
//  SLDownLoadQueue.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "SLDownLoadQueue.h"
#import "DownLoadTools.h"
#import "SLSessionManager.h"
#import "SLFileManager.h"

NSString *const DownLoadArchiveKey = @"DownLoadQueueArr";
NSString *const CompletedDownLoadArchiveKey = @"CompletedDownLoadQueueArr";

@implementation SLDownLoadQueue


-(instancetype)init{
    if (self = [super init]) {
        //默认同时下载数量为3，不易过多而导致开辟太多线程
        _maxDownLoadTask = 3;
    }
    
    return self;
}

+(SLDownLoadQueue *)downLoadQueue{

    static SLDownLoadQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[SLDownLoadQueue alloc]init];
    });
    
    return queue;
}

-(SLDownLoadModel *)nextDownLoadModel{
    
    for (SLDownLoadModel *model in self.downLoadQueueArr) {
        if (DownLoadStateWaiting == model.downLoadState) {
            return model;
        }
    }
    return nil;
}

//刷新下载
-(void)updateDownLoad{

    int i = 0;
    for (SLDownLoadModel *model in self.downLoadQueueArr) {
        if (DownLoadStateDownloading == model.downLoadState) {
            i++;
        }
    }
    //新增下载任务
    for (int m = 0; m < self.maxDownLoadTask - i; m++) {
        [self startDownload];
    }
}

#pragma mark - 添加下载任务到下载队列中

-(void)addDownTaskWithDownLoadModel:(SLDownLoadModel *)model{
    //SLog(@"%p",model);
    if (model) {
        SLDownLoadModel *modelTmp = model;
        //SLog(@"%p",modelTmp);
        
        modelTmp.downLoadTask = nil;
        modelTmp.downLoadState = DownLoadStateWaiting;
        
        modelTmp.totalByetes = 0.f;
        modelTmp.downLoadedByetes = 0.f;
        modelTmp.downLoadSpeed = 0.f;
        modelTmp.downLoadProgress = 0.f;
        
        modelTmp.isDelete = NO;
        modelTmp.isEditStatus = NO;
        
        //SLog(@"%@",modelTmp.fileUUID);
        [self.downLoadQueueArr addObject:modelTmp];
        [self updateDownLoad];
    }
}

//下载完成
-(void)completedDownLoadWithModel:(SLDownLoadModel *)model{
    
    //将已经下载完成的任务添加到下载完成数据源
    if ([self.downLoadQueueArr containsObject:model]) {
        //需要把此属性置空才能归档
        model.downLoadTask = nil;
        [self.completedDownLoadQueueArr addObject:model];
        [self.downLoadQueueArr removeObject:model];
    }
    
    [self updateDownLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:DownLoadResourceFinished object:nil];
    
    //将下载完的的进行归档
    [DownLoadTools archiveDownLoadModelArrWithModelArr:self.completedDownLoadQueueArr withKey:CompletedDownLoadArchiveKey andPath:CompletedDownLoad_Archive];
}

#pragma mark - 执行下载
-(void)startDownload{
    
    SLDownLoadModel *model = [self nextDownLoadModel];
    
    if (nil == model) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    __block NSDate *oldDate = [NSDate date]; //记录上次的数据回传的时间
    __block float  downLoadBytesTmp = 0;     //记录上次数据回传的大小
    
    NSString *fullPath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:model.fileUUID];
    
    if ([SLFileManager isExistPath:fullPath]) { //说明有缓存，该缓存文件是个XML文件，包含了关于下载有关的信息，在调用pause之后生成
        
        NSError *err = nil;
        NSData *resumeData = [NSData dataWithContentsOfFile:fullPath options:NSDataReadingMappedIfSafe error:&err];
        if (err) {
            SLog(@"%@",err.localizedDescription);
            return;
        }
        
        SLSessionManager *manager = [SLSessionManager sessionManager];
        model.downLoadTask = [manager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //NSLog(@"下载中。。。。。。%lld",downloadProgress.completedUnitCount);
            model.downLoadedByetes = downloadProgress.completedUnitCount; //已经下载的
            model.totalByetes = downloadProgress.totalUnitCount; //总大小
            model.downLoadProgress = model.downLoadedByetes/model.totalByetes; //下载百分比进度
            
            NSDate *currentDate = [NSDate date];
            double num = [currentDate timeIntervalSinceDate:oldDate]; //时间差，就是本次block被调用的时间减去上一次该block被调用的时间
            if ( num >= 1) {
                model.downLoadSpeed = (model.downLoadedByetes - downLoadBytesTmp)/num;
                
                downLoadBytesTmp = model.downLoadedByetes;
                oldDate = currentDate;
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            //注意：：：
            //在此处发送通知，当下载任务完成之后，等一会程序会崩溃，这个问题困扰了我好几小时，my god
            
            //此处只会调用一次，当下载完成后调用
            model.downLoadState = DownLoadStateDownloadfinished;
            //model.downLoadedByetes = model.totalByetes;
            //model.downLoadProgress = 1;
            
            NSString *destinationStr = [[SLFileManager getDownloadRootDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.fileUUID]];
            return [NSURL fileURLWithPath:destinationStr];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            //此处在下载完成和取消下载的时候都会被调用
            [weakSelf updateDownLoad];
            
            //一定要做判断
            if (model.downLoadState == DownLoadStateDownloadfinished) {
                [weakSelf completedDownLoadWithModel:model];
            }
        }];
        
    }else{
        
        SLSessionManager *manager = [SLSessionManager sessionManager];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.downLoadUrlStr]];
        
        model.downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //NSLog(@"下载中___。。。。。。%lld-----共++++%lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            //NSLog(@"===========%@",[NSThread currentThread]);
            model.downLoadedByetes = downloadProgress.completedUnitCount; //已经下载的
            model.totalByetes = downloadProgress.totalUnitCount; //总大小
            model.downLoadProgress = model.downLoadedByetes/model.totalByetes; //下载百分比进度
            
            NSDate *currentDate = [NSDate date];
            double num = [currentDate timeIntervalSinceDate:oldDate]; //时间差，就是本次block被调用的时间减去上一次该block被调用的时间
            if ( num >= 1) {
                model.downLoadSpeed = (model.downLoadedByetes - downLoadBytesTmp)/num;
                downLoadBytesTmp = model.downLoadedByetes;
                oldDate = currentDate;
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            //注意：：：
            //在此处发送通知，当人下载任务完成之后，等一会程序会崩溃，这个问题困扰了我好几小时，my god
            
            //此处只会调用一次，当下载完成后调用
            model.downLoadState = DownLoadStateDownloadfinished;
            //model.downLoadedByetes = model.totalByetes;
            //model.downLoadProgress = 1;
            
            NSString *destinationStr = [[SLFileManager getDownloadRootDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.fileUUID]];
            
            return [NSURL fileURLWithPath:destinationStr];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            //此处在下载完成和取消下载的时候都会被调用
            
            //NSLog(@"*********##%@",[[SLFileManager getDownloadRootDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.fileUUID]]);
            NSLog(@"下载完成或暂停下载++++++");
            
            [weakSelf updateDownLoad];
            if (model.downLoadState == DownLoadStateDownloadfinished) {
                [weakSelf completedDownLoadWithModel:model];
            }
        }];
    }

    [model.downLoadTask resume]; //开始下载
    model.downLoadState = DownLoadStateDownloading;
}

//开始下载或暂停下载
-(void)startOrPauseDownLoadWithModel:(SLDownLoadModel *)model{

}

#pragma mark - 恢复某一下载任务
-(void)resumeWithDownLoadModel:(SLDownLoadModel *)model{
    //如果在暂停状态或者等待下载状态则恢复下载
    if (DownLoadStatePause == model.downLoadState) {
        model.downLoadState = DownLoadStateWaiting;
    }
    [self updateDownLoad];
}

-(void)startDownloadAll{
    
    for (SLDownLoadModel *model in self.downLoadQueueArr) {
        if (DownLoadStatePause == model.downLoadState) {
            model.downLoadState = DownLoadStateWaiting;
        }
    }
    
    [self updateDownLoad];
}

#pragma mark - 暂停下载
-(void)pauseWithDownLoadModel:(SLDownLoadModel *)model{
    //如果在下载状态或者等待下载状态则暂停
    NSLog(@"***********暂停************");
    if ((DownLoadStateDownloading == model.downLoadState)||(DownLoadStateWaiting == model.downLoadState)) {

        //取消是异步的
        [model.downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            NSString *cachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:model.fileUUID];
            [resumeData writeToFile:cachePath atomically:YES];
        }];
        //置空，防止归档时出错
        model.downLoadTask = nil;
        //更改状态
        model.downLoadState = DownLoadStatePause;
        //更新下载
        [self updateDownLoad];
    }
}

-(void)pauseAll{

    for (SLDownLoadModel *model in self.downLoadQueueArr) {
        //如果在下载状态或者等待下载状态则暂停
        if ((DownLoadStateDownloading == model.downLoadState)||(DownLoadStateWaiting == model.downLoadState)) {
        
            //取消下载是异步的
            [model.downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
    
                NSString *cachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:model.fileUUID];
                [resumeData writeToFile:cachePath atomically:YES];
            }];
            //置空，防止归档时出错
            model.downLoadTask = nil;
            //更改状态
            model.downLoadState = DownLoadStatePause;
            //SLog(@"取消下载中。。。。。");
        }
    }
    //更新下载
    [self updateDownLoad];
}

#pragma mark - 懒加载
-(NSMutableArray<SLDownLoadModel *> *)downLoadQueueArr{
    
    if (!_downLoadQueueArr) {
        _downLoadQueueArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _downLoadQueueArr;
}

-(NSMutableArray<SLDownLoadModel *> *)completedDownLoadQueueArr{
    if (!_completedDownLoadQueueArr) {
        _completedDownLoadQueueArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _completedDownLoadQueueArr;
}

-(void)appWillTerminate{
    SLog(@"app将要被杀死。。。。");
    [self pauseAll];
    //给点时间进行异步暂停所有下载
    sleep(10);
    
    //归档正在下载或等待下载的
    [DownLoadTools archiveDownLoadModelArrWithModelArr:self.downLoadQueueArr withKey:DownLoadArchiveKey andPath:DownLoad_Archive];
    
    //归档已经下载完的
    [DownLoadTools archiveDownLoadModelArrWithModelArr:self.completedDownLoadQueueArr withKey:DownLoadArchiveKey andPath:CompletedDownLoad_Archive];
}

@end
