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
    [allSelectedBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [allSelectedBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [allSelectedBtn addTarget:self action:@selector(deleteAllWithButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allSelectedBtn];
    
    UIBarButtonItem *spaceItem =[ [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    
    self.toolbarItems = @[leftBarButtonItem,spaceItem,deleteBarButtonItem];
}


-(void)deleteAllWithButton:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要全部删除吗" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editAction:editBtn];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAllAction:button];
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 删除
-(void)deleteAllAction:(UIButton *)button{
    //SLog(@"全部非选中状态");
    if (_segmentCtl.selectedSegmentIndex == 0) {
        
        [_tableViewOne.deleteDataArr addObjectsFromArray:_tableViewOne.dataArr];
        
        for (SLDownLoadModel *model in _tableViewOne.deleteDataArr) {
            
            [SLDownLoadQueue deleteDownLoadWithModel:model];
        }        [_tableViewOne.dataArr removeAllObjects];
        [_tableViewOne.deleteDataArr removeAllObjects];
        _tableViewOne.editing = NO;
        [_tableViewOne reloadData];
        
        [SLDownLoadQueue updateDownLoad];
        
    }else{
        
        [_tableViewTwo.deleteDataArr addObjectsFromArray:_tableViewTwo.dataArr];
        for (SLDownLoadModel *model in _tableViewTwo.deleteDataArr) {
            [SLDownLoadQueue deleteDownLoadWithModel:model];
        }
        [_tableViewTwo.deleteDataArr removeAllObjects];
        _tableViewTwo.editing = NO;
        [_tableViewTwo reloadData];

    }
    [self setToolBarHidden:YES animation:YES];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
}

#pragma mark - 底部右边删除按钮
-(void)deleteAction:(UIButton *)button{
    
    if (_segmentCtl.selectedSegmentIndex == 0) {
        
        for (SLDownLoadModel *model in _tableViewOne.deleteDataArr) {
            
            [SLDownLoadQueue deleteDownLoadWithModel:model];
        }
        [_tableViewOne.deleteDataArr removeAllObjects];
        _tableViewOne.editing = NO;
        [_tableViewOne reloadData];
        
    }else{
        
        for (SLDownLoadModel *model in _tableViewTwo.deleteDataArr) {
            [SLDownLoadQueue deleteDownLoadWithModel:model];
        }
        
        [_tableViewTwo.deleteDataArr removeAllObjects];
        _tableViewTwo.editing = NO;
        [_tableViewTwo reloadData];
        
    }
    
    [self setToolBarHidden:YES animation:YES];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
}

#pragma mark - 编辑按钮
-(void)editAction:(UIButton *)button{
    
    if ([button.currentTitle isEqualToString:@"取消"]) {  //执行编辑操作
        //SLog(@"隐藏cell上的选中按钮");
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        
        if (_segmentCtl.selectedSegmentIndex == 0) {
            //隐藏toolbar
            [self setToolBarHidden:YES animation:YES];
            _tableViewOne.editing = NO;
            [_tableViewOne reloadData];
            [_tableViewOne.deleteDataArr removeAllObjects];
        }else{
            [self setToolBarHidden:YES animation:YES];
            _tableViewTwo.editing = NO;
            [_tableViewTwo reloadData];
            [_tableViewTwo.deleteDataArr removeAllObjects];
        }
        
    }else{
        //SLog(@"显示cell上的选中按钮");
        [button setTitle:@"取消" forState:UIControlStateNormal];
  
        if (_segmentCtl.selectedSegmentIndex == 0) {
            //显示toolbar
            [self setToolBarHidden:NO animation:YES];
            _tableViewOne.editing = YES;
            [_tableViewOne reloadData];
            [_tableViewOne.deleteDataArr removeAllObjects];
        }else{
            //显示toolbar
            [self setToolBarHidden:NO animation:YES];
            _tableViewTwo.editing = YES;
            [_tableViewTwo reloadData];
            [_tableViewTwo.deleteDataArr removeAllObjects];
        }
    }
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
        _tableViewOne = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain andStyle:DownLoadTableViewStyleDowloading];
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
    [SLDownLoadQueue startDownloadAll];
}

//全部暂停下载
-(void)allStopAction:(UIButton *)button{
    //SLog(@"全部暂停下载");
    [SLDownLoadQueue pauseAll];
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
            
            _tableViewOne = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain andStyle:DownLoadTableViewStyleDowloading];
            [self.view addSubview:_tableViewOne];
            _tableViewOne.isDownLoadCompletedTableView = NO;
            //屏幕适配
            [_tableViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
            _tableViewOne.tableHeaderView = [self createHeaderViewWithTable:_tableViewOne];
        }
        
        _tableViewOne.editing = NO;
        _tableViewOne.hidden = NO;
        if (_tableViewTwo) {
            _tableViewTwo.hidden = YES;
            _tableViewTwo.editing = NO;
        }
        
        //toolbar
        [self.navigationController setToolbarHidden:YES animated:YES];
        editBtn.selected = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [_tableViewOne reloadData];
        
    }else if (1 == index){
        
        if (!_tableViewTwo) {
            
            _tableViewTwo = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain andStyle:DownLoadTableViewStyleCompleted];
            [self.view addSubview:_tableViewTwo];
            _tableViewTwo.isDownLoadCompletedTableView = YES;
            
            //布局适配
            [_tableViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
            _tableViewTwo.tableHeaderView = [self createHeaderViewWithTable:_tableViewTwo];
        }
        
        _tableViewOne.hidden = YES;
        _tableViewOne.editing = NO;
        _tableViewTwo.hidden = NO;
        _tableViewTwo.editing = NO;
  
        [self.navigationController setToolbarHidden:YES animated:YES];
        editBtn.selected = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [_tableViewTwo reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
