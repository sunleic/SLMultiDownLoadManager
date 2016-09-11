//
//  DownLoadHeader.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#ifndef DownLoadHeader_h
#define DownLoadHeader_h

typedef NS_ENUM(NSInteger, DownLoadState){
    DownLoadStateWaiting,           //等待下载，最大下载数规定为3个，大于三个任务就挂起等待
    DownLoadStatePause,             //下载暂停
    DownLoadStateDownloading,       //下载中
    DownLoadStateDownloadfinished   //下载完成
};

#define SLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define DOWNLOAD_ROOT_DIR  @"VideoDownloadRoot"
#define DOWNLOAD_CACHE_DIR @"VideoDownloadCache"

#define FIEL_UUID  [[NSUUID UUID] UUIDString]

//归档路径，分别为正在下载的归档路径和已经下载完成的归档路径
#define DownLoad_Archive_Path [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:@"downLoadArchive"]
#define CompletedDownLoad_Archive_Path [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:@"completedDownLoadArchive"]

//正在下载的model进行归档时的key
extern NSString *const DownLoadArchiveKey;
//下载完成的model进行归档时的key
extern NSString *const CompletedDownLoadArchiveKey;
//下载完成的通知
extern NSString *const DownLoadResourceFinished;

//删除下载列表中的cell
#define CellIsDeleted @"CellIsDeleted"

#import "AFNetworking.h"
#import "Masonry.h"

#import "DownLoadTools.h"
#import "SLFileManager.h"
#import "SLSessionManager.h"

#endif /* DownLoadHeader_h */
