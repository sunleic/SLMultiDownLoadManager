//
//  Tools.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/11.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "Tools.h"
#import "SLFileManager.h"
#import "DownLoadHeader.h"

@implementation Tools

+ (BOOL)archiveCompleteDownLoadModelWithModelArr:(NSMutableArray *)arr withKey:(NSString *)keyStr{

    //归档已经下载完的
    NSMutableData *completeDownLoadData = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:completeDownLoadData];
    
    [archiver encodeObject:arr forKey:keyStr];
    //SLog(@"%@",self.completedDownLoadQueueArr);
    [archiver finishEncoding];
    
    BOOL isSucess = [completeDownLoadData writeToFile:CompletedDownLoad_Archive atomically:YES];
    
    return isSucess;
}

+ (NSMutableArray *)unArchiveCompleteDownLoadModelWithKey:(NSString *)key{
    //解归档已下载完的
    NSData *data2 = [[NSMutableData alloc] initWithContentsOfFile:CompletedDownLoad_Archive];
    NSKeyedUnarchiver *unarchiver2 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
    NSMutableArray *archivingArr = [unarchiver2 decodeObjectForKey:key];
    //SLog(@"%@",archivingArr);
    [unarchiver2 finishDecoding];

    return archivingArr;
}

@end
