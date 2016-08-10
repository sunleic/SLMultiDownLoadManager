//
//  SLDownLoadModel.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "SLDownLoadModel.h"

@implementation SLDownLoadModel

/*
 
 @property (nonatomic, strong)   NSURLSessionDownloadTask *downLoadTask;  //当前资源下载任务
 @property (nonatomic, assign)   DownLoadState downLoadState;             //当前下载状态
 
 @property (nonatomic, copy)     NSString *fileUUID;             //生成的UUID作为文件名
 @property (nonatomic, copy)     NSString *title;                //下载资源的标题
 @property (nonatomic, copy)     NSString *downLoadUrlStr;       //下载资源的URL
 
 @property (nonatomic, assign)   float     totalByetes;          //下载资源的总大小
 @property (nonatomic, assign)   float     downLoadedByetes;     //当前已下载量的大小
 @property (nonatomic, assign)   float     downLoadSpeed;        //下载速度
 @property (nonatomic, assign)   float     downLoadProgress;     //下载进度  百分比
 
 @property (nonatomic, assign)   float     isDelete;             //是否要被删除
 */

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.downLoadTask    forKey:@"downLoadTask"];
    [aCoder encodeInteger:self.downLoadState  forKey:@"downLoadState"];
    
    [aCoder encodeObject:self.fileUUID        forKey:@"fileUUID"];
    [aCoder encodeObject:self.title           forKey:@"title"];
    [aCoder encodeObject:self.downLoadUrlStr  forKey:@"downLoadUrlStr"];
    
    [aCoder encodeFloat:self.totalByetes      forKey:@"totalByetes"];
    [aCoder encodeFloat:self.downLoadedByetes forKey:@"downLoadedByetes"];
    [aCoder encodeFloat:self.downLoadSpeed    forKey:@"downLoadSpeed"];
    [aCoder encodeFloat:self.downLoadProgress forKey:@"downLoadProgress"];
    
    [aCoder encodeBool:self.isDelete          forKey:@"isDelete"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {
        _downLoadTask     = [aDecoder decodeObjectForKey:@"downLoadTask"];
        _downLoadState    = [aDecoder decodeIntegerForKey:@"downLoadState"];
        
        _fileUUID         = [aDecoder decodeObjectForKey:@"fileUUID"];
        _title            = [aDecoder decodeObjectForKey:@"title"];
        _downLoadUrlStr   = [aDecoder decodeObjectForKey:@"downLoadUrlStr"];
        
        _totalByetes      = [aDecoder decodeFloatForKey:@"totalByetes"];
        _downLoadedByetes = [aDecoder decodeFloatForKey:@"downLoadedByetes"];
        _downLoadSpeed    = [aDecoder decodeFloatForKey:@"downLoadSpeed"];
        _downLoadProgress = [aDecoder decodeFloatForKey:@"downLoadProgress"];
        
        _isDelete         = [aDecoder decodeBoolForKey:@"isDelete"];
    }
    
    return self;
}

@end
