//
//  AlbumShareView.m
//  ShiJia
//
//  Created by 峰 on 16/9/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "AlbumShareView.h"
#import "SJShareButton.h"
#import "ShareCell.h"

@interface AlbumShareView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIControl         *controlView;
@property (nonatomic, strong) UIView            *middleView;
@property (nonatomic, strong) UIButton          *cancelButton;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UILabel           *label2;

@property (nonatomic, strong) NSArray *dataDictArray;

@end

@implementation AlbumShareView

-(NSArray *)dataDictArray{
    if (!_dataDictArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:SocialPlistName ofType:@"plist"];
        _dataDictArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _dataDictArray;
}

-(void)setTitleString:(NSString *)titleString{
    if (titleString.length>0) {
        _label2.text = [NSString stringWithFormat:@"    %@",titleString];
    }else{
        [_label2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_collectionView.mas_top).offset(0);
        }];
    }
}

#pragma mark UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataDictArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
//
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

//    CGFloat SpaceHeight = (SCREEN_WIDTH-40-250)/4;

    return 0;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    return UIEdgeInsetsMake(0,10,10,10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
    if (indexPath.row<_dataDictArray.count) {
        //        [cell setCellModel:_currentShowData[indexPath.row]];
        [cell setCellmodelDict:_dataDictArray[indexPath.row]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row ==1|indexPath.row==2) {
        if (![WXApi isWXAppInstalled]) {
            [MBProgressHUD showError:@"未安装微信客户端" toView:nil];
            [self performSelectorInBackground:@selector(hiddleFromSuperView) withObject:nil];
            return;
        }
    }

    if ([self.photoShareDelegate respondsToSelector:@selector(PhotoShareToSocailName:)]) {
        [self.photoShareDelegate PhotoShareToSocailName:(indexPath.row)];
    }
    [self performSelectorInBackground:@selector(hiddleFromSuperView) withObject:nil];
}




-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-40)/5,85);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellWithReuseIdentifier:@"ShareCell"];
    }
    return _collectionView;
}

-(UILabel *)label2{
    if (!_label2) {
        _label2 =[UILabel new];
        _label2.backgroundColor = [UIColor whiteColor];
        //        _label2.text = @"分享到微信、朋友圈、微博、通讯录";
        _label2.font = [UIFont systemFontOfSize:12.];
        _label2.textColor = RGB(154, 154, 154, 1);
        _label2.textAlignment  = 0;
        [_label2 sizeToFit];
        [_middleView addSubview:_label2];

    }
    return _label2;
}

-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [UIView new];

        UIImageView *imageLine1 = [UIImageView new];
        imageLine1.backgroundColor = kColorBlueTheme;
        [_middleView addSubview:imageLine1];
        [imageLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(2.);
            make.left.mas_equalTo(_middleView).offset(20.);
            make.top.mas_equalTo(_middleView).offset(13.);
            make.height.mas_equalTo(16.);
        }];

        UILabel *label = [UILabel new];
        label.text = @"分享";
        label.font = [UIFont systemFontOfSize:18.];
        [label sizeToFit];
        [_middleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageLine1.mas_right).offset(7.);
            make.centerY.mas_equalTo(imageLine1);
        }];

        UIImageView *imageLine2 = [UIImageView new];
        imageLine2.backgroundColor = RGB(229, 229, 229, 1);
        [_middleView addSubview:imageLine2];
        [imageLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_middleView);
            make.height.mas_equalTo(1.);
            make.top.mas_equalTo(_middleView).offset(40.);
        }];

        _middleView.backgroundColor = [UIColor whiteColor];

    }
    return _middleView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.tag = 0;
        _cancelButton.backgroundColor =[UIColor whiteColor];
        [_cancelButton setTitleColor:RGB(68, 68, 68, 1) forState:UIControlStateNormal];
        __weak __typeof(self)weakSelf = self;
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hiddleFromSuperView];
        }];
        //        [_cancelButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(void)addSubViewsConstraints{
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(50.);
    }];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_cancelButton.mas_top).offset(-4);
        make.height.mas_equalTo(85);

    }];

    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(_collectionView.mas_top);
        make.height.mas_equalTo(20);
    }];

    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_collectionView.mas_top).offset(-20);
        make.height.mas_equalTo(41.);
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;

        _controlView=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _controlView.backgroundColor=RGB(0, 0, 0, 0.3);
        [_controlView addTarget:self action:@selector(controlViewClick) forControlEvents:UIControlEventTouchUpInside];
        _controlView.alpha=0;
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.cancelButton];
        [self addSubview:self.collectionView];
        [self addSubview:self.label2];
        [self addSubview:self.middleView];
        [self addSubViewsConstraints];
        [_collectionView reloadData];
    }
    return self;
}

- (void)buttonClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (_photoShareDelegate) {
        if ([self.photoShareDelegate respondsToSelector:@selector(PhotoShareToSocailName:)]) {
            [self.photoShareDelegate PhotoShareToSocailName:(button.tag-10)];
        }
    }

}

- (void)controlViewClick {

    [self hiddleFromSuperView];
}

- (void)AlbumShareShowInView:(UIView *)superView {
    if (self.isHidden) {
        self.hidden = NO;
        if (_controlView.superview==nil) {
            [superView addSubview:_controlView];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _controlView.alpha=1;
        }];
        CATransition *animation = [CATransition  animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype =kCATransitionFromTop;
        [self.layer addAnimation:animation forKey:@"animation1"];
        self.frame = CGRectMake(0,superView.frame.size.height-180, SCREEN_WIDTH,180);
        [superView addSubview:self];
    }
}

- (void)hiddleFromSuperView {
    if (!self.isHidden) {
        self.hidden = YES;
        CATransition *animation = [CATransition  animation];
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        [UIView animateWithDuration:0.2 animations:^{
            _controlView.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}




@end
