//
//  DownLoadingTableViewCell.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DownLoadingTableViewCell.h"

@implementation DownLoadingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setUI];
    }
    return self;
}

-(void)setUI{
    //背景图
    _backgroundImg = [UIImageView new];
    _backgroundImg.userInteractionEnabled = YES;
//    _backgroundImg.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:_backgroundImg];
    
    //选择是否删除的按钮
    self.selectBtn = [UIButton new];
    [_backgroundImg addSubview:self.selectBtn];
    
    //缩略图
    self.imgView = [UIImageView new];
//    _imgView.backgroundColor = [UIColor redColor];
    [_imgView setImage:[UIImage imageNamed:@"tmp"]];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    [_backgroundImg addSubview:self.imgView];
    //标题
    self.titleLbl = [UILabel new];
    self.titleLbl.font = [UIFont systemFontOfSize:14];
//    _titleLbl.backgroundColor = [UIColor redColor];
    [_backgroundImg addSubview:self.titleLbl];
    //状态，显示速度或暂停
    self.statusLbl = [UILabel new];
    self.statusLbl.textAlignment = NSTextAlignmentLeft;
    self.statusLbl.adjustsFontSizeToFitWidth = YES;
    self.statusLbl.font = [UIFont systemFontOfSize:12];
//    _statusLbl.backgroundColor = [UIColor yellowColor];
    [_backgroundImg addSubview:self.statusLbl];
    //下载进度
    self.progressLbl = [UILabel new];
    self.progressLbl.textAlignment = NSTextAlignmentRight;
    self.progressLbl.adjustsFontSizeToFitWidth = YES;
    self.progressLbl.font = [UIFont systemFontOfSize:12];
//    _progressLbl.backgroundColor = [UIColor yellowColor];
    [_backgroundImg addSubview:self.progressLbl];
    
    self.progressView = [UIProgressView new];
//    _progressView.backgroundColor = [UIColor yellowColor];
//    _progressView.progress = 0.3;
    [_backgroundImg addSubview:self.progressView];
    
    //适配
    [_backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    
    //被注释的部分，是在要点击编辑按钮的时候要实现的部分
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_backgroundImg).offset(0);
        make.bottom.equalTo(_backgroundImg).offset(0);
        make.right.equalTo(self.imgView.mas_left).offset(0);
        make.width.mas_equalTo(0);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_backgroundImg).offset(0);
        make.width.mas_equalTo(100);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundImg).offset(5);
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.right.equalTo(_backgroundImg).offset(-5);
        
        make.height.mas_equalTo(20);
    }];
    
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_progressView.mas_top).offset(-3);
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.width.equalTo(@100);
        make.height.mas_equalTo(13);
    }];
    
    [self.progressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_statusLbl.mas_centerY);
        make.right.equalTo(_backgroundImg.mas_right).offset(-5);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.equalTo(_statusLbl.mas_height);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.bottom.mas_equalTo(-4);
        make.right.equalTo(_backgroundImg.mas_right).offset(-5);
        make.height.mas_equalTo(2);
    }];
}

-(void)setDownLoadModel:(SLDownLoadModel *)downLoadModel{
    
    if (downLoadModel == nil) {
        SLog(@"下载数据模型为空");
        return;
    }
    if (_downLoadModel) {
        [self removeOberver];
        _downLoadModel = nil;
    }
    _downLoadModel = downLoadModel;
    [self addObserver];
    
    //删除按钮的选中状态
    if (_downLoadModel.isDelete) {
        self.selectBtn.backgroundColor = [UIColor redColor];
        //重置约束
        [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(_backgroundImg).offset(20);
            make.bottom.equalTo(_backgroundImg).offset(-20);
            make.right.equalTo(_imgView.mas_left).offset(-10);
            make.width.mas_equalTo(_selectBtn.mas_height);
        }];
        
    }else{
        self.selectBtn.backgroundColor = [UIColor greenColor];
        //重置约束
        [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(_backgroundImg).offset(0);
            make.bottom.equalTo(_backgroundImg).offset(-20);
            make.right.equalTo(_imgView.mas_left).offset(0);
            make.width.mas_equalTo(0);
        }];
    }
    
    //编辑按钮的状态
    if (_downLoadModel.isEditStatus) {
        //重置约束
        [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(_backgroundImg).offset(20);
            make.bottom.equalTo(_backgroundImg).offset(-20);
            make.right.equalTo(_imgView.mas_left).offset(-10);
            make.width.mas_equalTo(_selectBtn.mas_height);
        }];
        
    }else{
        //重置约束
        [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(_backgroundImg).offset(0);
            make.bottom.equalTo(_backgroundImg).offset(-20);
            make.right.equalTo(_imgView.mas_left).offset(0);
            make.width.mas_equalTo(0);
        }];
    }
    //赋值
    [self setValueForCell];
}

-(void)addObserver{
    /*
     double  totalByetes;
     float   downLoadedByetes;
     float   downLoadSpeed;
     float   downLoadProgress;
     */
    [_downLoadModel addObserver:self forKeyPath:@"downLoadState" options:NSKeyValueObservingOptionNew context:nil];
    [_downLoadModel addObserver:self forKeyPath:@"downLoadSpeed" options:NSKeyValueObservingOptionNew context:NULL];
    [_downLoadModel addObserver:self forKeyPath:@"downLoadedByetes" options:NSKeyValueObservingOptionNew context:NULL];
    [_downLoadModel addObserver:self forKeyPath:@"downLoadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(void)removeOberver{
    
    [_downLoadModel removeObserver:self forKeyPath:@"downLoadState"];
    [_downLoadModel removeObserver:self forKeyPath:@"downLoadSpeed"];
    [_downLoadModel removeObserver:self forKeyPath:@"downLoadedByetes"];
    [_downLoadModel removeObserver:self forKeyPath:@"downLoadProgress"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新UI
        [self setValueForCell];
    });
}

//给cell对应的属性赋值
-(void)setValueForCell{

    //标题
    self.titleLbl.text = _downLoadModel.title;
    if (_downLoadModel.downLoadState == DownLoadStatePause) {
        self.statusLbl.text = @"暂停下载";
    }else if (_downLoadModel.downLoadState == DownLoadStateSuspend){
        self.statusLbl.text = @"等待下载";
    }else if (_downLoadModel.downLoadState == DownLoadStateDownloadfinished){
        self.statusLbl.text = @"下载完成";
    }else{
        
        float value = _downLoadModel.downLoadSpeed;
        if (value >= 0 && value < 1024 ) {
            
            self.statusLbl.text = [NSString stringWithFormat:@"%.2fB/s",value];
        }else if (value >= 1024 && value < 1024 * 1024){
            
            self.statusLbl.text = [NSString stringWithFormat:@"%.2fKB/s",value/1024];
        }else if (value >= 1024 * 1024 && value < 1024 * 1024 * 1024){
            
            self.statusLbl.text = [NSString stringWithFormat:@"%.2fMB/s",value/1024/1024];
        }
    }
    
    self.progressLbl.text = [NSString stringWithFormat:@"%.1fM/%.0fM",_downLoadModel.downLoadedByetes/(1024*1024),_downLoadModel.totalByetes/(1024*1024)];
    
    self.progressView.progress = _downLoadModel.downLoadProgress;
}

-(void)dealloc{

    NSLog(@"++++++%s++++",__func__);
    //在此处一定要移除监听，不然继续进行kvo监听，然而被监听的对象已经不存在了，这样会崩溃
    [self removeOberver];
}

@end
