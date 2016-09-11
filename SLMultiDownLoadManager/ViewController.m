//
//  ViewController.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadHeader.h"
#import "DownloadViewController.h"
#import "SLDownLoadModel.h"
#import "SLDownLoadQueue.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_W - 200)/2, 100, 200, 40)];
    button1.backgroundColor = [UIColor cyanColor];
    [button1 setTitle:@"添加下载任务" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_W - 200)/2, 200, 200, 40)];
    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"进入下载列表" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


//添加下载任务
-(void)btn1Action{
    //创建临时任务
    [self createDownloadTask];
}

-(void)btnAction{

    DownloadViewController *vc = [[DownloadViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


//此处只是为了测试临时添加的下载任务
-(void)createDownloadTask{
    
    SLDownLoadModel *model1 = [[SLDownLoadModel alloc]init];
    
    model1.resourceID = [[[NSUUID UUID] UUIDString] stringByAppendingString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    model1.downLoadUrlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    model1.thumbnailUrlStr = @"";
    model1.title = model1.resourceID;
    
    [SLDownLoadQueue addDownTaskWithDownLoadModel:model1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
