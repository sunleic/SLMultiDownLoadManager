//
//  AppDelegate.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionHandle)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy)  completionHandle backgroundSessionCompletionHandler;


@end

