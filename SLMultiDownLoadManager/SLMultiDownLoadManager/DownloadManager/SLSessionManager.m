//
//  SLSessionManager.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "SLSessionManager.h"

@implementation SLSessionManager

static SLSessionManager *sessionManager = nil;
+(SLSessionManager *)sessionManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[SLSessionManager alloc]init];
    });
    
    return sessionManager;
}

@end
