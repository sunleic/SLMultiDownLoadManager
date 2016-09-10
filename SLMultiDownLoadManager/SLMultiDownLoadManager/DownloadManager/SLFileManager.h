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

//返回系统Documents路径
+(NSString *)getDocumentsPath;

//返回系统Liarbry路径
+(NSString *)getLiarbryPath;

//获取Liarbry/Caches目录
+(NSString *)getLiarbryCachesPath;

//获取系统tmp缓存路径
+(NSString *)getTmpPath;


//是否存在指定的文件或目录
+(BOOL)isExistPath:(NSString *)pathStr;


//创建一个指定的的目录
+(BOOL)createPath:(NSString *)path;


//删除制定路径的文件或目录
+(BOOL)deletePathWithName:(NSString *)pathName;

//将sourcePath路径的文件或文件夹移动到destinationPath路径中
+(BOOL)moveItemPath:(NSString *)sourcePath toItemPath:(NSString *)destinationPath;

@end
