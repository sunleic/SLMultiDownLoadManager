//
//  SLFileManager.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "SLFileManager.h"
#import "DownLoadHeader.h"

@implementation SLFileManager

/**
*  获取下载资源的根目录，该目录存放已经下载好的资源，/Library/Caches/VideoDownloadRoot
*
*  @return 返回下载资源的根目录
*/
+(NSString *)getDownloadRootDir{
    
    NSString *cacheDir = [SLFileManager getLiarbryCachesPath];
;
    NSString *path = [cacheDir stringByAppendingPathComponent:DOWNLOAD_ROOT_DIR];
    
    if (![SLFileManager isExistPath:path]) {
        ;
        if ([SLFileManager createPath:path]) {
            return path;
        }else{
            return nil;
        }
    }
    
    return path;
}

/**
 *  获取下载资源的缓存目录，该目录的内容包括用于断点续传的resumeData文件和归档的文件，/Library/Caches/VideoDownloadCache
 *
 *  @return 返回下载资源的缓存目录
 */
+(NSString *)getDownloadCacheDir{
    
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
;
    NSString *path = [cacheDir stringByAppendingPathComponent:DOWNLOAD_CACHE_DIR];
    
    if (![SLFileManager isExistPath:path]) {
        ;
        if ([SLFileManager createPath:path]) {
            return path;
        }else{
            return nil;
        }
    }
    return path;
}

/**
 *  是否存在指定的文件或目录
 *
 *  @param pathStr 自定的文件路径或目录路径
 *
 *  @return YES 表示存在指定的路径 NO 表示不存在
 */
+(BOOL)isExistPath:(NSString *)pathStr{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSCachesDirectory 中是否存在pathName
    if ([fileManager fileExistsAtPath:pathStr]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  创建一个指定的的目录
 *
 *  @param path 创建一个指定的的目录
 *
 *  @return YES创建成功
 */
+(BOOL)createPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSCachesDirectory 中是否存在pathName
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }else{
        NSError *err = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        if (err) {
            NSLog(@"%@",err.localizedDescription);
            return NO;
        }else{
            return YES;
        }
    }
}


/**
 *  删除制定路径的文件或目录
 *
 *  @param pathName 文件名或目录名
 *
 *  @return 删除成功为YES 失败为NO
 */
+(BOOL)deletePathWithName:(NSString *)pathName{
    
    if (pathName == nil) {
        NSLog(@"%s---%d---%@",__func__,__LINE__,@"你指定的路径为nil");
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
    [fileManager removeItemAtPath:pathName error:&err];
    if (!err) {
        return YES;
    }else{
        NSLog(@"%@",err.localizedDescription);
        return NO;
    }
}

/**
 *  将sourcePath路径的文件或文件夹移动到destinationPath路径中
 *
 *  @param sourcePath      源路径
 *  @param destinationPath 目的路径
 *
 *  @return 移动成功返回YES
 */
+(BOOL)moveItemPath:(NSString *)sourcePath toItemPath:(NSString *)destinationPath{
    
    NSError *err = nil;
    BOOL isSucess = [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:&err];
    
    if (!err && isSucess) {
        return YES;
    }else{
        NSLog(@"%@",err.localizedDescription);
        return NO;
    }
}

/**
 *  返回沙河目录
 *
 *  @return 返回沙河目录
 */
+(NSString *)getHomeDictionary{
 
    return NSHomeDirectory();
}

/**
 *  获取系统Documents路径
 *
 *  @return 返回系统Documents路径
 */
+(NSString *)getDocumentsPath{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


/**
 *  获取系统Liarbry路径
 *
 *  @return 返回系统Liarbry路径
 */
+(NSString *)getLiarbryPath{
    
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  返回Liarbry/Caches目录
 *
 *  @return 返回Liarbry/Caches目录
 */
+(NSString *)getLiarbryCachesPath{

    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取系统tmp缓存路径
 *
 *  @return 返回系统缓tmp存路径
 */
+(NSString *)getTmpPath{
    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [[SLFileManager getHomeDictionary] stringByAppendingPathComponent:@"tmp"];
}

@end
