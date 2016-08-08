//
//  SLFileManager.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFileManager : NSObject

//获取下载资源的根目录
+(NSString *)getDownloadRootDir;

//获取下载资源的缓存目录
+(NSString *)getDownloadCacheDir;

//在下载资源根目录是否存在指定的文件
+(BOOL)isExistDownloadRootDir;

//是否存在指定的文件或目录
+(BOOL)isExistPath:(NSString *)pathStr;

//创建下载资源的根目录
+(BOOL)createDownloadRootDir;

//创建一个指定的的目录
+(BOOL)createPath:(NSString *)path;

//删除制定路径的文件或目录
+(BOOL)deletePathWithName:(NSString *)pathName;

@end
