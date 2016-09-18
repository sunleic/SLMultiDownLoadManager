//
//  Tools.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/11.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DownLoadTools.h"
#include <sys/mount.h>
#import "SLFileManager.h"
#import "DownLoadHeader.h"

@implementation DownLoadTools

//归档
+ (BOOL)archiveDownLoadModelArrWithModelArr:(NSMutableArray *)arr withKey:(NSString *)keyStr andPath:(NSString *)path{

    //归档已经下载完的
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:arr forKey:keyStr];
    //SLog(@"%@",self.completedDownLoadQueueArr);
    [archiver finishEncoding];
    
    BOOL isSucess = [data writeToFile:path atomically:YES];
    
    return isSucess;
}

//解归档
+ (NSMutableArray *)unArchiveDownLoadModelArrWithKey:(NSString *)key andPath:(NSString *)path{
    //解归档已下载完的
    NSData *data2 = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver2 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
    NSMutableArray *archivingArr = [unarchiver2 decodeObjectForKey:key];
    //SLog(@"%@",archivingArr);
    [unarchiver2 finishDecoding];

    return archivingArr;
}

//"/private/var"    "/"
//获取磁盘剩余空间
+ (long long)getDiskFreeSpaceEx{
    
    struct statfs buf;
    long long freespace;
    freespace = 0;
    
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace ;
}

//获取磁盘的总大小
+ (long long)getDiskTotalSpaceEx{
    
    struct statfs buf;
    long long totalspace = 0;
    
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    
    return totalspace;
}

@end
