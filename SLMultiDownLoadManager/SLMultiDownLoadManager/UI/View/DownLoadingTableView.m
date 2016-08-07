//
//  DownLoadingTableView.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DownLoadingTableView.h"
#import "DownLoadHeader.h"
#import "DownLoadingTableViewCell.h"
#import "SLDownLoadQueue.h"


@interface DownLoadingTableView ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DownLoadingTableView

- (instancetype)initWithFrame:(CGRect)rect style:(UITableViewStyle)tableViewStyle WithDataSource:(NSMutableArray *)dataSource
{
    self = [super initWithFrame:rect style:tableViewStyle];
    if (self) {
        
        self.isDownLoadCompletedTableView = NO;
        
        if (dataSource) {
            self.dataArr = dataSource;
        }else{
            self.dataArr = [NSMutableArray arrayWithCapacity:0];
        }
        
        self.dataSource = self;
        self.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinished) name:DownLoadResourceFinished object:nil];
    }
    return self;
}

#pragma mark -下载完成监听
-(void)downLoadFinished{
    [self reloadData];
}

#pragma mark -tableview相关协议方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * const cellReuseID = @"cellID";
    
    DownLoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    
    if (!cell) {
        cell = [[DownLoadingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseID];
    }

    cell.downLoadModel = _dataArr[indexPath.row];
    
    if (self.isDownLoadCompletedTableView == YES) {
        cell.statusLbl.hidden = YES;
        cell.progressLbl.hidden = YES;
        cell.progressView.hidden = YES;
    }else{
        cell.statusLbl.hidden = NO;
        cell.progressLbl.hidden = NO;
        cell.progressView.hidden = NO;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    /*
     DownLoadStateSuspend,           //等待下载，最大下载数规定为3个，大于三个任务就挂起等待
     DownLoadStatePause,             //下载暂停
     DownLoadStateDownloading,       //下载中
     DownLoadStateDownloadfinished   //下载完成
     */
    
    if (self.isDownLoadCompletedTableView) {
        NSLog(@"您点击了已经下载完成的第 %lu 行",indexPath.row);
    }else{
    
        SLDownLoadModel *model = [[tableView cellForRowAtIndexPath:indexPath] downLoadModel];
        
        switch (model.downLoadState) {
            case DownLoadStateDownloading:
            {
                [[SLDownLoadQueue downLoadQueue] pauseWithDownLoadModel:model];
            }
                break;
            case DownLoadStateSuspend:
            {
                model.downLoadState = DownLoadStatePause;
                [[SLDownLoadQueue downLoadQueue] updateDownLoad];
            }
                break;
            case DownLoadStatePause:
            {
                model.downLoadState = DownLoadStateSuspend;
                [[SLDownLoadQueue downLoadQueue] updateDownLoad];
            }
                break;
                
            default:
                break;
        }
    }
    
    
}

@end
