//
//  Tools.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/11.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//归档下载完的model数组
+ (BOOL)archiveCompleteDownLoadModelWithModelArr:(NSMutableArray *)arr withKey:(NSString *)keyStr;

//返回解归档下载完的model数组
+ (NSMutableArray *)unArchiveCompleteDownLoadModelWithKey:(NSString *)key;

@end
