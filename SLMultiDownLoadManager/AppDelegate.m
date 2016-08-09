//
//  AppDelegate.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SLFileManager.h"
#import "SLDownLoadQueue.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    NSLog(@"%@",NSHomeDirectory());
    [self getDownLoadCache];
    
    return YES;
}


-(void)getDownLoadCache{
    
    //读取下载任务，以及已经下载完成的
    SLDownLoadQueue *queue = [SLDownLoadQueue downLoadQueue];
    //待下载的
    NSString *downLoadCachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:@"downLoadQueueArr"];
    //解归档待下载的
    NSData *data1 = [[NSMutableData alloc] initWithContentsOfFile:downLoadCachePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
    NSMutableArray *archivingdownLoadQueueArr = [unarchiver decodeObjectForKey:@"downLoadQueueArr"];
    [unarchiver finishDecoding];
    
    if (archivingdownLoadQueueArr) {
        for (SLDownLoadModel *model in archivingdownLoadQueueArr) {
            [queue addDownTaskWithDownLoadModel:model];
        }
    }
    
    //解归档已下载完的
    NSString *completeDownLoadCachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:@"completedDownLoadQueueArr"];
    
    NSData *data2 = [[NSMutableData alloc] initWithContentsOfFile:completeDownLoadCachePath];
    NSKeyedUnarchiver *unarchiver2 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
    NSMutableArray *archivingArr = [unarchiver2 decodeObjectForKey:@"completedDownLoadQueueArr"];
    [unarchiver2 finishDecoding];
    
    if (archivingArr) {
        queue.completedDownLoadQueueArr = [archivingArr copy];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //将要进入前台的时候刷新一下，防止下载停止，虽然他们的状态是正在下载或待下载状态
    [[SLDownLoadQueue downLoadQueue] updateDownLoad];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //app被杀死的时候做一些本地处理
    [[SLDownLoadQueue downLoadQueue] appViewTerminate];
}

@end
