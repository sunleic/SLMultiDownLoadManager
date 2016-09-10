//
//  DownLoadingTableView.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deleteSucess)();

@interface DownLoadingTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr; //数据源

@property (nonatomic, strong) NSMutableArray *deleteDataArr; //要被删除的数据

@property (nonatomic, assign) BOOL isDownLoadCompletedTableView; //表示是否是下载完成的table


- (instancetype)initWithFrame:(CGRect)rect style:(UITableViewStyle)tableViewStyle WithDataSource:(NSMutableArray *)dataSource;



@end
