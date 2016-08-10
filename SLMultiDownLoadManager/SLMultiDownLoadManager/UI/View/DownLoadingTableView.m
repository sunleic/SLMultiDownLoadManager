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
#import "SLFileManager.h"


@interface DownLoadingTableView ()

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
        
        //任务下载完成
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
    
    [cell.selectBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.tag = indexPath.row;

    return cell;
}

-(void)deleteBtn:(UIButton *)button{
    
    SLDownLoadModel *model = _dataArr[button.tag];
    if (!model) {
        return;
    }
    
    DownLoadingTableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
  
    if (model.isDelete == NO) {
        model.isDelete = YES;
        cell.selectBtn.backgroundColor = [UIColor redColor];
    }else{
        model.isDelete = NO;
        cell.selectBtn.backgroundColor = [UIColor greenColor];
    }
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

#pragma mark --删除cell
//编辑的风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回删除效果
    return UITableViewCellEditingStyleDelete;
}
//点击左边删除按钮时  显示的右边删除button的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//提交编辑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //当你删除时
        //NSLog(@"第%lu行被删除了",indexPath.row);
        
        //删除视频和用于断点续传的缓存文件
        NSString *cachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:[_dataArr[indexPath.row] fileUUID]];
        
        if ([SLFileManager isExistPath:cachePath]) {
            [SLFileManager deletePathWithName:cachePath];
        }
        
        NSString *destinationStr = [[SLFileManager getDownloadRootDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[_dataArr[indexPath.row] fileUUID]]];
        if ([SLFileManager isExistPath:destinationStr]) {
            [SLFileManager deletePathWithName:destinationStr];
        }

        //先将数据源中的数据删除了
        [_dataArr removeObjectAtIndex:indexPath.row];
        //以动画的形式删除指定的cell
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        if (self.isDownLoadCompletedTableView == NO) {
            [[SLDownLoadQueue downLoadQueue] updateDownLoad];
        }
    }
}

//删除被选中的cell
-(void)deleteSelectedCells:(deleteSucess)deleteSucess{
    
    for (SLDownLoadModel *model in self.dataArr) {
        if (model.isDelete) {
            
            //删除视频和用于断点续传的缓存文件
            NSString *cachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:model.fileUUID];
            
            if ([SLFileManager isExistPath:cachePath]) {
                [SLFileManager deletePathWithName:cachePath];
            }
            
            NSString *destinationStr = [[SLFileManager getDownloadRootDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.fileUUID]];
            if ([SLFileManager isExistPath:destinationStr]) {
                [SLFileManager deletePathWithName:destinationStr];
            }

            //要被删除的的cell的model，最后在更新
            [_dataArr removeObject:model];
        }
    }
    [self reloadData];
    
    //刷新下载任务
    
    [[SLDownLoadQueue downLoadQueue] updateDownLoad];

    
    //每次批量删除之后要复位
    deleteSucess();
}

-(void)dealloc{

    NSLog(@"%s---%d",__func__,__LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
