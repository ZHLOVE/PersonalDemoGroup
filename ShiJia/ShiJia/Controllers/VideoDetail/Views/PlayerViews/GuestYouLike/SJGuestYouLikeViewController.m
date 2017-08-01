//  Created by 峰 on 16/7/22.
//  Copyright © 2016年 mhh. All rights reserved.
//

#import "SJGuestYouLikeViewController.h"
#import "CollectionViewCell.h"


@interface SJGuestYouLikeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *navItemButton;
@property (nonatomic) BOOL   isProatian;
@property (nonatomic) CGSize layoutSize;

@end

@implementation SJGuestYouLikeViewController

-(UIView *)navView{
    if (!_navView) {
        _navView = [UIView new];
        _navView.backgroundColor = RGB(0, 0, 0, 0.8);
        _navItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_navItemButton setTitle:@"返回" forState:UIControlStateNormal];
        [_navItemButton setImage:[UIImage imageNamed:@"white_back_btn"] forState:UIControlStateNormal];
        [_navItemButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_navItemButton];
        [_navItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navView);
            make.left.mas_equalTo(_navView).offset(10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(44);
        }];
        UILabel *label = [UILabel new];
        label.text = @"收视推荐";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:19.0];
        [_navView addSubview:label];
        [label sizeToFit];
        label.textAlignment = 1 ;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_navView);
            make.centerX.mas_equalTo(_navView);
        }];
    }
    return _navView;
}

-(void)clickButton:(id)sender{
    
   
    if (self.isProatian) {
         [self.view removeFromSuperview];
        if (_clickBlock) {
            self.clickBlock(sender);
        }
        
    }else{
        
        [self setDevicePortrait];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self getCurrentOrtainer];
    
    self.view.backgroundColor = [UIColor darkGrayColor];

    _collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionFlowLayout.minimumInteritemSpacing = 10;
    _collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 获取 UICollectionView 的对象
    
    _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero
                                        collectionViewLayout:_collectionFlowLayout];
    _collectionView.backgroundColor = [UIColor darkGrayColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.layer.cornerRadius = 3.0f;
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.view  addSubview:_collectionView];
    [self.view addSubview:self.navView];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,140));
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(15);
        make.bottom.mas_equalTo(self.view).offset(-10);
    }];

}
- (void)getCurrentOrtainer{

    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        
        //横屏
        self.layoutSize =  CGSizeMake(170,253);
        self.isProatian = NO;
        
    }else if(SCREEN_WIDTH < SCREEN_HEIGHT){
        self.isProatian = YES;
        //竖屏
        self.layoutSize = CGSizeMake(146,110);
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];

    [cell setcontentWith:self.modelsArray[indexPath.row]];
    return cell;
}



- (CGSize )collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return   self.layoutSize;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WatchListEntity *model = self.modelsArray[indexPath.row];
    if ([_deleage respondsToSelector:@selector(chooseOneWatchEntityFromGuestList:)]) {
        [self.deleage chooseOneWatchEntityFromGuestList:model];
    }
    [self.view removeFromSuperview];
    
}

- (void)orientationChanged:(NSNotification *)notification{
    // 收到 设备旋转 通知
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGSize layoutSize ;
    //UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (screenSize.width > screenSize.height) {
        self.view.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*9/16);
        //横屏
        self.layoutSize = CGSizeMake(170,253);
        self.isProatian = NO;
        [_collectionFlowLayout setItemSize:self.layoutSize];
        [self.collectionView reloadData];
        self.currentScreenisFull = YES;
        
    }else{
        self.isProatian = YES;
        self.currentScreenisFull = NO;
        //竖屏
        self.layoutSize = CGSizeMake(146,110);
        [_collectionFlowLayout setItemSize:self.layoutSize];
        self.view.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*9/16);
        [self.collectionView reloadData];

    }
    
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
