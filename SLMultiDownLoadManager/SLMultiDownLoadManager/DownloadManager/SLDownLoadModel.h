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

//下载资源的唯一标示符，作为resumedata描述文件的名字
//下载后资源的名字（对于视频的命名是resourceID.mp4）
@property (nonatomic, copy)     NSString *resourceID;
@property (nonatomic, copy)     NSString *title;                //下载资源的标题
@property (nonatomic, copy)     NSString *thumbnailUrlStr;      //对应资源的缩略图
@property (nonatomic, copy)     NSString *downLoadUrlStr;       //下载资源的URL

@property (nonatomic, assign)   float     totalByetes;          //下载资源的总大小
@property (nonatomic, assign)   float     downLoadedByetes;     //当前已下载量的大小
@property (nonatomic, assign)   float     downLoadSpeed;        //下载速度
@property (nonatomic, assign)   float     downLoadProgress;     //下载进度  百分比

@property (nonatomic, assign)   BOOL      isDelete;             //是否要被删除
@property (nonatomic, assign)   BOOL      isEditStatus;         //是否在编辑状态

@end
