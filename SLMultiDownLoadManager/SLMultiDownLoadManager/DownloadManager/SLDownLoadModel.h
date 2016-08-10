//
//  SLDownLoadModel.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadHeader.h"

@interface SLDownLoadModel : NSObject<NSCoding>


@property (nonatomic, strong)   NSURLSessionDownloadTask *downLoadTask;  //当前资源下载任务
@property (nonatomic, assign)   DownLoadState downLoadState;             //当前下载状态

@property (nonatomic, copy)     NSString *fileUUID;             //生成的UUID作为文件名
@property (nonatomic, copy)     NSString *title;                //下载资源的标题
@property (nonatomic, copy)     NSString *downLoadUrlStr;       //下载资源的URL

@property (nonatomic, assign)   float     totalByetes;          //下载资源的总大小
@property (nonatomic, assign)   float     downLoadedByetes;     //当前已下载量的大小
@property (nonatomic, assign)   float     downLoadSpeed;        //下载速度
@property (nonatomic, assign)   float     downLoadProgress;     //下载进度  百分比

@property (nonatomic, assign)   BOOL     isDelete;             //是否要被删除

@end
