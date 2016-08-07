//
//  DownloadViewController.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownLoadingTableView.h"
#import "DownLoadHeader.h"
#import "SLDownLoadQueue.h"
#import "SLDownLoadModel.h"

@interface DownloadViewController ()

@property (nonatomic, strong) DownLoadingTableView *tableViewOne; //下载中
@property (nonatomic, strong) DownLoadingTableView *tableViewTwo; //下载完成

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createDownloadTask];
    [self createContents];
}

-(void)createDownloadTask{
    
    /*
     fileUUID;
     title;
     downLoadUrlStr;
     totalByetes;
     downLoadedByetes;
     downLoadSpeed;
     downLoadProgress;
     */
    
    SLDownLoadModel *model1 = [[SLDownLoadModel alloc]init];
    
    model1.fileUUID = [[NSUUID UUID] UUIDString];
    model1.title = @"阿斯顿发送到阿斯顿发送到阿斯顿发送到阿斯顿发送到";
    model1.downLoadUrlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    model1.downLoadState = DownLoadStateSuspend;
    
    [[SLDownLoadQueue downLoadQueue] addDownTaskWithDownLoadModel:model1];
    
    
    SLDownLoadModel *model2 = [[SLDownLoadModel alloc]init];
    
    model2.fileUUID = [[NSUUID UUID] UUIDString];
    model2.title = @"测试2.....";
    model2.downLoadUrlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    model2.downLoadState = DownLoadStateSuspend;
    
    [[SLDownLoadQueue downLoadQueue] addDownTaskWithDownLoadModel:model2];
    
    
    SLDownLoadModel *model3 = [[SLDownLoadModel alloc]init];
    
    model3.fileUUID = [[NSUUID UUID] UUIDString];
    model3.title = @"阿斯顿发送到阿斯顿发送到阿斯顿发送到阿斯顿发送到";
    model3.downLoadUrlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    model3.downLoadState = DownLoadStateSuspend;
    
    [[SLDownLoadQueue downLoadQueue] addDownTaskWithDownLoadModel:model3];
    
    
    SLDownLoadModel *model4 = [[SLDownLoadModel alloc]init];
    
    model4.fileUUID = [[NSUUID UUID] UUIDString];
    model4.title = @"测试2.....";
    model4.downLoadUrlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    model4.downLoadState = DownLoadStateSuspend;
    
    [[SLDownLoadQueue downLoadQueue] addDownTaskWithDownLoadModel:model4];
}

-(void)createContents{
    
    UISegmentedControl *segmentCtl = [[UISegmentedControl alloc]initWithItems:@[@"下载中",@"已下载"]];
    segmentCtl.selectedSegmentIndex = 0;
    [segmentCtl setWidth:90 forSegmentAtIndex:0];
    [segmentCtl setWidth:90 forSegmentAtIndex:1];
    [segmentCtl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentCtl;
    
    if (!_tableViewOne) {
        _tableViewOne = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain WithDataSource:[SLDownLoadQueue downLoadQueue].downLoadQueueArr];
        [self.view addSubview:_tableViewOne];
        
        [_tableViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
    }
}

-(void)segmentClick:(UISegmentedControl *)segmentCtl{

    NSInteger index = segmentCtl.selectedSegmentIndex;
    if (0 == index) {
        
        if (!_tableViewOne) {
            _tableViewOne = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain WithDataSource:[SLDownLoadQueue downLoadQueue].downLoadQueueArr];
            [self.view addSubview:_tableViewOne];
            _tableViewTwo.isDownLoadCompletedTableView = NO;
            
            [_tableViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
        }
        
        if (_tableViewTwo) {
            _tableViewTwo.hidden = YES;
        }
        _tableViewOne.hidden = NO;
        
        [_tableViewOne reloadData];
        
    }else if (1 == index){
        
        if (!_tableViewTwo) {
            _tableViewTwo = [[DownLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain WithDataSource:[SLDownLoadQueue downLoadQueue].completedDownLoadQueueArr];
            [self.view addSubview:_tableViewTwo];
            _tableViewTwo.isDownLoadCompletedTableView = YES;
            
            [_tableViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
        }
        if (_tableViewOne) {
            _tableViewOne.hidden = YES;
        }
        _tableViewTwo.hidden = NO;
        
        [_tableViewTwo reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
