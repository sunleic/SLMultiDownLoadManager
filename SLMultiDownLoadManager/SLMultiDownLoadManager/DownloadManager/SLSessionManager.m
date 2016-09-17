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
        
        NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        //最大并发下载数
        configuration.HTTPMaximumConnectionsPerHost = 3;
        
        //当在后台完成传输的时候是否启动恢复或者启动APP
        configuration.sessionSendsLaunchEvents = YES;
        
        configuration.discretionary = YES;
        
        sessionManager = [[SLSessionManager alloc]initWithSessionConfiguration:configuration];
        
        //开启检测网络
        [sessionManager.reachabilityManager startMonitoring];
    });
    
    return sessionManager;
}

@end
