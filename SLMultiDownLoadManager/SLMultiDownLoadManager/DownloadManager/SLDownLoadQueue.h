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

@interface SLDownLoadQueue : NSObject<UIAlertViewDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableArray <SLDownLoadModel *> *downLoadQueueArr;  //装载非下载完成状态的model
@property (nonatomic, strong) NSMutableArray <SLDownLoadModel *> *completedDownLoadQueueArr;  //装载已经下载完成的model

////下载manager
@property (nonatomic, strong) SLSessionManager *sessionManager;

//添加下载任务到下载队列中
+(void)addDownLoadTaskWithModel:(SLDownLoadModel *)model;

//删除一个下载
+(void)deleteDownLoadWithModel:(SLDownLoadModel *)model;

//全部开始下载
+(void)startDownloadAll;

///开始或暂停下载
+(void)startOrStopDownloadWithModel:(SLDownLoadModel *)model;

//全部暂停
+(void)pauseAll;

//刷新下载
+(void)updateDownLoad;

//读取已经下载的model和短点的model
+(void)getDownLoadCache;

//程序将要被杀死的时候
+(void)appWillTerminate;

+(SLDownLoadQueue *)downLoadQueue;

@end
