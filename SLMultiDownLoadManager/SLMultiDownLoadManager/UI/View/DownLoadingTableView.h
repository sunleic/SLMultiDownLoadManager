//
//  DownLoadingTableView.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DownLoadTableViewStyle) {
    DownLoadTableViewStyleDowloading = 0,     //表示该tableview是正在下载的
    DownLoadTableViewStyleCompleted           //表示该tableview是下载完成的
    
};

typedef void(^deleteSucess)();

@interface DownLoadingTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr; //数据源

@property (nonatomic, strong) NSMutableArray *deleteDataArr; //要被删除的数据

@property (nonatomic, assign) BOOL isDownLoadCompletedTableView; //表示是否是下载完成的table


- (instancetype)initWithFrame:(CGRect)rect style:(UITableViewStyle)tableViewStyle andStyle:(DownLoadTableViewStyle)DownLoadTableViewStyle;



@end
