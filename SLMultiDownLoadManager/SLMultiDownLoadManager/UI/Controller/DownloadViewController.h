//
//  DownloadViewController.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloadViewControllerDelegate <NSObject>

-(void)deleteSelectedCell;

@end

@interface DownloadViewController : UIViewController

@property (nonatomic, assign) id <DownloadViewControllerDelegate> delegate;

@end
