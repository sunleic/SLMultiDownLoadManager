//
//  Tools.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/11.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//归档
+ (void)archiveCompleteDownLoadModelWithModelArr:(NSMutableArray *)arr withKey:(NSString *)keyStr;

@end
