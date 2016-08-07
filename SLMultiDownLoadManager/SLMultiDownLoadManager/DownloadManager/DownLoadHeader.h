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
    DownLoadStateSuspend,           //等待下载，最大下载数规定为3个，大于三个任务就挂起等待
    DownLoadStatePause,             //下载暂停
    DownLoadStateDownloading,       //下载中
    DownLoadStateDownloadfinished   //下载完成
};

#define SLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define CACHE_DIR [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define DOWNLOAD_ROOT_DIR  @"VideoDownload"
#define DOWNLOAD_CACHE_DIR @"VideoDownloadCache"

#define FIEL_UUID  [[NSUUID UUID] UUIDString]

//通知
#define DownLoadResourceFinished @"DownLoadResourceFinished"


#import "AFNetworking.h"
#import "Masonry.h"

#endif /* DownLoadHeader_h */
