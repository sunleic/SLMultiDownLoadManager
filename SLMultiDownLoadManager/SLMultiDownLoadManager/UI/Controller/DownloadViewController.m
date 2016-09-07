//
//  DownloadViewController.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownLoadingTableView.h"
#import "DownLoadingTableViewCell.h"
#import "DownLoadHeader.h"
#import "SLDownLoadQueue.h"
#import "SLDownLoadModel.h"

@interface DownloadViewController ()

@property (nonatomic, strong) UISegmentedControl   *segmentCtl;
@property (nonatomic, strong) DownLoadingTableView *tableViewOne; //下载中
@property (nonatomic, strong) DownLoadingTableView *tableViewTwo; //下载完成

@end

@implementation DownloadViewController{

    NSMutableArray *_deleteCellArr;
    UIButton *editBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //导航条编辑按钮
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 40, 30);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBarButtionItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtionItem;
    
    //创建UI
    [self createContents];
}

#pragma mark - 设置toolBar的隐藏或再显
-(void)setToolBarHidden:(BOOL)hidden animation:(BOOL)animate{

    //toolbar
    [self.navigationController setToolbarHidden:hidden animated:animate];
    
    UIButton *allSelectedBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [allSelectedBtn setTitle:@"全部选中" forState:UIControlStateNormal];
    [allSelectedBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [allSelectedBtn addTarget:self action:@selector(allSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allSelectedBtn];
    
    UIBarButtonItem *spaceItem =[ [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    
    self.toolbarItems = @[leftBarButtonItem,spaceItem,deleteBarButtonItem];
}

#pragma mark - 全部选中或全部不选中
-(void)allSelectedAction:(UIButton *)button{
    
    if (button.selected) { //全选中
        //SLog(@"全部非选中状态");
        if (_segmentCtl.selectedSegmentIndex == 0) {
            for (SLDownLoadModel *model in [[SLDownLoadQueue downLoadQueue] downLoadQueueArr]) {
                model.isDelete = NO;
            }
            [_tableViewOne reloadData];
        }else{
            for (SLDownLoadModel *model in [[SLDownLoadQueue downLoadQueue] completedDownLoadQueueArr]) {
                model.isDelete = NO;
            }
            [_tableViewTwo reloadData];
        }
        
    }else{
        //SLog(@"全部选中状态");
        if (_segmentCtl.selectedSegmentIndex == 0) {
            for (SLDownLoadModel *model in [[SLDownLoadQueue downLoadQueue] downLoadQueueArr]) {
                model.isDelete = YES;
            }
            [_tableViewOne reloadData];
        }else{
            for (SLDownLoadModel *model in [[SLDownLoadQueue downLoadQueue] completedDownLoadQueueArr]) {
                model.isDelete = YES;
            }
            [_tableViewTwo reloadData];
        }
    }
    button.selected = !button.selected;
}

#pragma mark - 底部删除按钮
-(void)deleteAction:(UIButton *)button{
    
    __weak typeof(self) weakSelf = self;
    
    if (_segmentCtl.selectedSegmentIndex == 0) {
        SLog(@"删除");
        [_tableViewOne deleteSelectedCells:^{
            //SLog(@"批量删除复位+++");
            [weakSelf remakeConstrainsToHideSelectedBtnOnTable:weakSelf.tableViewOne];
            [weakSelf.tableViewOne reloadData];
            [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            editBtn.selected = !editBtn.selected;
        }];
    }else{

        [_tableViewTwo deleteSelectedCells:^{
            //SLog(@"批量删除复位+++");
            [weakSelf remakeConstrainsToHideSelectedBtnOnTable:weakSelf.tableViewTwo];
            [weakSelf.tableViewTwo reloadData];
            [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            editBtn.selected = !editBtn.selected;
        }];
    }
}

#pragma mark - 编辑按钮
-(void)editAction:(UIButton *)button{
    
    if (button.selected) {  //执行编辑操作
        //SLog(@"隐藏cell上的选中按钮");
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        
        if (_segmentCtl.selectedSegmentIndex == 0) {
            [self remakeConstrainsToHideSelectedBtnOnTable:_tableViewOne];
        }else{
            [self remakeConstrainsToHideSelectedBtnOnTable:_tableViewTwo];
        }
        
    }else{
        //SLog(@"显示cell上的选中按钮");
        [button setTitle:@"取消" forState:UIControlStateNormal];
  
        if (_segmentCtl.selectedSegmentIndex == 0) {
            [self remakeConstrainsToShowSelectedBtnOnTable:_tableViewOne];
        }else{
            [self remakeConstrainsToShowSelectedBtnOnTable:_tableViewTwo];
        }
    }
    button.selected = !button.selected;
}

//显示批量选择按钮
-(void)remakeConstrainsToShowSelectedBtnOnTable:(UITableView *)table{
    //显示toolbar
    [self setToolBarHidden:NO animation:YES];
    for (SLDownLoadModel *model in [self getAllModelWithTable:table]) {
        model.isEditStatus = YES;
    }
    [table reloadData];
}

//隐藏批量选择按钮
-(void)remakeConstrainsToHideSelectedBtnOnTable:(UITableView *)table{
    //隐藏toolbar
    [self setToolBarHidden:YES animation:YES];
    for (SLDownLoadModel *model in [self getAllModelWithTable:table]) {
        model.isEditStatus = NO;
    }
    
    [table reloadData];
}

//获得指定tableview的可见cell们
-(NSArray *)getAllModelWithTable:(UITableView *)tableView{

    DownLoadingTableView *table = (DownLoadingTableView *)tableView;

    if (table.isDownLoadCompletedTableView) {
        
        return [[SLDownLoadQueue downLoadQueue] completedDownLoadQueueArr];
    }else{
        return [[SLDownLoadQueue downLoadQueue] downLoadQueueArr];
    }
    
}

-(void)createContents{
    _segmentCtl = [[UISegmentedControl alloc]initWithItems:@[@"下载中",@"已下载"]];
    _segmentCtl.selectedSegmentIndex = 0;
    [_segmentCtl setWidth:90 forSegmentAtIndex:0];
    [_segmentCtl setWidth:90 forSegmentAtIndex:1];
    [_segmentCtl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentCtl;
    
    if (!_tableViewOne) {
        _tableViewOne = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain WithDataSource:[SLDownLoadQueue downLoadQueue].downLoadQueueArr];
        _tableViewOne.isDownLoadCompletedTableView = NO;
        [self.view addSubview:_tableViewOne];
        //屏幕适配
        [_tableViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
        //头
        _tableViewOne.tableHeaderView = [self createHeaderViewWithTable:_tableViewOne];
    }
}

-(UIView *)createHeaderViewWithTable:(DownLoadingTableView *)tableView{
   
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    tableHeaderView.backgroundColor = [UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.00];
    
    if (tableView.isDownLoadCompletedTableView) {
        
        UIButton *lookAllBtn = [UIButton new];
        [lookAllBtn setTitle:@"点击查看全部" forState:UIControlStateNormal];
        [lookAllBtn addTarget:self action:@selector(lookAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableHeaderView addSubview:lookAllBtn];
        [lookAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(tableHeaderView);
            make.width.mas_equalTo(200);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        
    }else{
    
        UIButton *allStartBtn = [UIButton new];
        [allStartBtn setTitle:@"全部开始" forState:UIControlStateNormal];
        //        allStartBtn.backgroundColor = [UIColor yellowColor];
        [tableHeaderView addSubview:allStartBtn];
        [allStartBtn addTarget:self action:@selector(allStartAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineLbl = [UILabel new];
        lineLbl.backgroundColor = [UIColor purpleColor];
        [tableHeaderView addSubview:lineLbl];
        
        UIButton *allStopBtn = [UIButton new];
        [allStopBtn setTitle:@"全部暂停" forState:UIControlStateNormal];
        //        allStopBtn.backgroundColor = [UIColor cyanColor];
        [tableHeaderView addSubview:allStopBtn];
        [allStopBtn addTarget:self action:@selector(allStopAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [allStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(tableHeaderView);
            make.width.equalTo(tableHeaderView).multipliedBy(0.48);
        }];
        
        [lineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerX.equalTo(tableHeaderView);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
    
        [allStopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(tableHeaderView);
            make.width.equalTo(tableHeaderView).multipliedBy(0.48);
        }];
    }
    
    return tableHeaderView;
}

//全部开始下载
-(void)allStartAction:(UIButton *)button{
    //SLog(@"全部开始下载");
    [[SLDownLoadQueue downLoadQueue] startDownloadAll];
}

//全部暂停下载
-(void)allStopAction:(UIButton *)button{
    //SLog(@"全部暂停下载");
    [[SLDownLoadQueue downLoadQueue] pauseAll];
}

//点击观看全部
-(void)lookAllAction:(UIButton *)buttion{
    SLog(@"点击查看全部");
}


#pragma mark -segmentControl
-(void)segmentClick:(UISegmentedControl *)segmentCtl{

    NSInteger index = segmentCtl.selectedSegmentIndex;
    if (0 == index) {
        
        if (!_tableViewOne) {
            
            _tableViewOne = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain WithDataSource:[SLDownLoadQueue downLoadQueue].downLoadQueueArr];
            [self.view addSubview:_tableViewOne];
            _tableViewTwo.isDownLoadCompletedTableView = NO;
            //屏幕适配
            [_tableViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
            //头
            _tableViewOne.tableHeaderView = [self createHeaderViewWithTable:_tableViewOne];
        }
        
        if (_tableViewTwo) {
            _tableViewTwo.hidden = YES;
        }
        _tableViewOne.hidden = NO;
        
        //为了确保，当某一个tableview正处于编辑状态的时候点击了segmentctl而出现的bug
        //隐藏toolbar，并将所以的的isDelete=NO;
        for (SLDownLoadModel *model in [[SLDownLoadQueue downLoadQueue] completedDownLoadQueueArr]) {
            model.isDelete = NO;
        }
        //toolbar
        [self.navigationController setToolbarHidden:YES animated:YES];
        editBtn.selected = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self remakeConstrainsToHideSelectedBtnOnTable:_tableViewTwo];
        
        [_tableViewOne reloadData];
        
    }else if (1 == index){
        
        if (!_tableViewTwo) {
            
            _tableViewTwo = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain WithDataSource:[SLDownLoadQueue downLoadQueue].completedDownLoadQueueArr];
            [self.view addSubview:_tableViewTwo];
            _tableViewTwo.isDownLoadCompletedTableView = YES;
            
            //布局适配
            [_tableViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
            
            //头
            _tableViewTwo.tableHeaderView = [self createHeaderViewWithTable:_tableViewTwo];
        }
        if (_tableViewOne) {
            _tableViewOne.hidden = YES;
        }
        _tableViewTwo.hidden = NO;
        
       
        //为了确保，当某一个tableview正处于编辑状态的时候点击了segmentctl而出现的bug
        //隐藏toolbar，并将所以的的isDelete=NO;
        for (SLDownLoadModel *model in [[SLDownLoadQueue downLoadQueue] downLoadQueueArr]) {
            model.isDelete = NO;
        }
        //toolbar
        [self.navigationController setToolbarHidden:YES animated:YES];
        editBtn.selected = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self remakeConstrainsToHideSelectedBtnOnTable:_tableViewTwo];
        
        [_tableViewTwo reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
