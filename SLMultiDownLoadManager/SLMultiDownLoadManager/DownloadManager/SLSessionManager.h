//
//  SLSessionManager.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadHeader.h"

@interface SLSessionManager : AFHTTPSessionManager

+(SLSessionManager *)sessionManager;

@end
