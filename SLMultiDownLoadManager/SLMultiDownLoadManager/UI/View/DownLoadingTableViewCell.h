//
//  DownLoadingTableViewCell.h
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/4.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLDownLoadModel.h"

@interface DownLoadingTableViewCell : UITableViewCell

@property (nonatomic, strong) SLDownLoadModel *downLoadModel;

@property (nonatomic, strong) UIImageView *backgroundImg;

@property (nonatomic, strong) UIImageView    *imgView;
@property (nonatomic, strong) UILabel        *titleLbl;
@property (nonatomic, strong) UILabel        *statusLbl;
@property (nonatomic, strong) UILabel        *progressLbl;
@property (nonatomic, strong) UIProgressView *progressView;
//@property (nonatomic, strong) UIButton       *selectBtn;

@end
