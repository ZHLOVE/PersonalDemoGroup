//
//  SJPhotoHelpViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPhotoHelpViewController.h"

@interface SJPhotoHelpViewController ()
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIImageView  *helpImageV;
@end

@implementation SJPhotoHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.scroller];
    [self.scroller addSubview:self.helpImageV];
    [self addSubViewsContrain];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(UIScrollView *)scroller{
    if (!_scroller) {
        _scroller = [UIScrollView new];
        _scroller.pagingEnabled = NO;
    }
    return _scroller;
}

-(UIImageView *)helpImageV{
    if (!_helpImageV) {
        _helpImageV = [UIImageView new];
        [_helpImageV setContentMode:UIViewContentModeScaleAspectFit];
        _helpImageV.image = [UIImage imageNamed:@"SJScreenFoot"];
    }
    return _helpImageV;
}
-(void)addSubViewsContrain{
    [_scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [_helpImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scroller);
        make.bottom.mas_equalTo(_scroller);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

@end
