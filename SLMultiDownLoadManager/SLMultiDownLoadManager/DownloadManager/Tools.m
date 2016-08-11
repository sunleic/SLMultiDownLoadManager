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

+ (void)archiveCompleteDownLoadModelWithModelArr:(NSMutableArray *)arr withKey:(NSString *)keyStr{

    //归档已经下载完的
    NSMutableData *completeDownLoadData = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:completeDownLoadData];
    
    [archiver encodeObject:arr forKey:keyStr];
    //SLog(@"%@",self.completedDownLoadQueueArr);
    [archiver finishEncoding];
    [completeDownLoadData writeToFile:CompletedDownLoad_Archive atomically:YES];
}

@end
