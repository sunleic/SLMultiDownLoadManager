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
#import "DownLoadTools.h"

@interface DownLoadingTableView ()

@end

@implementation DownLoadingTableView

- (instancetype)initWithFrame:(CGRect)rect style:(UITableViewStyle)tableViewStyle andStyle:(DownLoadTableViewStyle)DownLoadTableViewStyle{
    
    self.allowsMultipleSelectionDuringEditing = YES;
    
    if (self = [super initWithFrame:rect style:tableViewStyle]) {
       
        if (DownLoadTableViewStyle == DownLoadTableViewStyleDowloading){
            self.dataArr = [SLDownLoadQueue downLoadQueue].downLoadQueueArr;
        }else if (DownLoadTableViewStyle == DownLoadTableViewStyleCompleted){
            self.dataArr = [SLDownLoadQueue downLoadQueue].completedDownLoadQueueArr;
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
    
    return 80;
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

    SLDownLoadModel *model = self.dataArr[indexPath.row];
    NSLog(@"---=====%@",model);
    if (tableView.editing == YES) {
        if (![self.deleteDataArr containsObject:model]) {
            [self.deleteDataArr addObject:model];
        }
        return;
    }
//    model.downLoadTask.taskIdentifier = 4;
    [SLDownLoadQueue startOrStopDownloadWithModel:model];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.editing == YES) {
        SLDownLoadModel *model = self.dataArr[indexPath.row];
        
        if ([self.deleteDataArr containsObject:model]) {
            [self.deleteDataArr removeObject:model];
        }
    }
}

/*
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
        SLDownLoadModel *model = _dataArr[indexPath.row];
        
        //删除视频和用于断点续传的缓存文件
        NSString *cachePath = [[SLFileManager getDownloadCacheDir] stringByAppendingPathComponent:model.fileUUID];
        
        if ([SLFileManager isExistPath:cachePath]) {
            [SLFileManager deletePathWithName:cachePath];
        }
        ///
        NSString *destinationStr = [[SLFileManager getDownloadRootDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.fileUUID]];
        if ([SLFileManager isExistPath:destinationStr]) {
            [SLFileManager deletePathWithName:destinationStr];
        }

        //先将数据源中的数据删除了
        [_dataArr removeObjectAtIndex:indexPath.row];
        //以动画的形式删除指定的cell
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        
        if (self.isDownLoadCompletedTableView == NO) {
            [[SLDownLoadQueue downLoadQueue] updateDownLoad];
        }else{
            //将剩下的下载完的的进行归档
            [DownLoadTools archiveDownLoadModelArrWithModelArr:_dataArr withKey:CompletedDownLoadArchiveKey andPath:CompletedDownLoad_Archive];
        }
    }
}
 */

#pragma mark - 懒加载数据源
-(NSMutableArray *)deleteDataArr{

    if (!_deleteDataArr) {
        _deleteDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _deleteDataArr;
}

-(void)dealloc{

    NSLog(@"%s---%d",__func__,__LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
