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
        
//        NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.sunlei"];
        //最大并发下载数
        configuration.HTTPMaximumConnectionsPerHost = 3;
        //当在后台完成传输的时候是否启动恢复或者启动APP
        configuration.sessionSendsLaunchEvents = YES;
        //是否允许性能优化，例如电量低的情况下系统有可能停止后台数据传输
        configuration.discretionary = YES;
        //请求超时时间
        configuration.timeoutIntervalForRequest = 15;
        //是否允许移动蜂窝网络
        configuration.allowsCellularAccess = YES;
        
        //创建后台下载回话对象
        sessionManager = [[SLSessionManager alloc]initWithSessionConfiguration:configuration];
        //好奇怪，以这种方式创建的回话对象也可以长时间在后台下载，莫非AF偷偷做处理了？？？？
//        sessionManager = [[SLSessionManager alloc]init];
        //开启网络检测
        [sessionManager.reachabilityManager startMonitoring];
    });
    
    return sessionManager;
}

@end
