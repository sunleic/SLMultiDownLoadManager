//
//  SLDownLoadQueue.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadHeader.h"
#import "SLDownLoadModel.h"

@interface SLDownLoadQueue : NSObject

@property (nonatomic, strong) NSMutableArray <SLDownLoadModel *> *downLoadQueueArr;  //装载非下载完成状态的model
@property (nonatomic, strong) NSMutableArray <SLDownLoadModel *> *completedDownLoadQueueArr;  //装载已经下载完成的model

//最大同时下载数量
@property (nonatomic, assign, readonly) NSInteger maxDownLoadTask;

//添加下载任务到下载队列中
-(void)addDownTaskWithDownLoadModel:(SLDownLoadModel *)model;

//刷新下载
-(void)updateDownLoad;
//全部开始下载
-(void)startDownloadAll;

//恢复某一下载任务
-(void)resumeWithDownLoadModel:(SLDownLoadModel *)model;

//控制某一正在下载 暂停下载
-(void)pauseWithDownLoadModel:(SLDownLoadModel *)model;
//全部暂停
-(void)pauseAll;

//程序将要被杀死的时候
//-(void)appViewTerminate;

+(SLDownLoadQueue *)downLoadQueue;

@end
