//
//  Tools.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/11.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DownLoadTools.h"
#import "SLFileManager.h"
#import "DownLoadHeader.h"

@implementation DownLoadTools

//归档
+ (BOOL)archiveDownLoadModelArrWithModelArr:(NSMutableArray *)arr withKey:(NSString *)keyStr andPath:(NSString *)path{

    //归档已经下载完的
    NSMutableData *completeDownLoadData = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:completeDownLoadData];
    
    [archiver encodeObject:arr forKey:keyStr];
    //SLog(@"%@",self.completedDownLoadQueueArr);
    [archiver finishEncoding];
    
    BOOL isSucess = [completeDownLoadData writeToFile:path atomically:YES];
    
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

@end
