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

//获取下载资源的根目录
+(NSString *)getDownloadRootDir{
    
    NSString *cacheDir = CACHE_DIR;
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

//获取下载资源的缓存目录
+(NSString *)getDownloadCacheDir{
    
    NSString *cacheDir = CACHE_DIR;
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

//在下载资源根目录是否存在指定的文件
+(BOOL)isExistDownloadRootDir{
    NSString *cacheDir = CACHE_DIR;
    
    NSString *downLoadPath = [cacheDir stringByAppendingPathComponent:DOWNLOAD_ROOT_DIR];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //NSCachesDirectory 中是否存在pathName
    if ([fileManager fileExistsAtPath:downLoadPath]) {
        
        return YES;
    }else{
        
        return NO;
    }
}


//是否存在指定的文件或目录
+(BOOL)isExistPath:(NSString *)pathStr{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSCachesDirectory 中是否存在pathName
    if ([fileManager fileExistsAtPath:pathStr]) {
        
        return YES;
    }else{
        
        return NO;
    }
}

//创建下载资源的根目录
+(BOOL)createDownloadRootDir{
    
    NSString *downLoadDir = [SLFileManager getDownloadRootDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
    [fileManager createDirectoryAtPath:downLoadDir withIntermediateDirectories:YES attributes:nil error:&err];
    if (!err) {
        return YES;
    }else{
        NSLog(@"%@",err.localizedDescription);
        return NO;
    }
}

//创建一个指定的的目录
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

//删除制定路径的文件或目录
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

@end
