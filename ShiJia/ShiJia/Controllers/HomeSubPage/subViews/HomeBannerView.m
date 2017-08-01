//
//  HomeBannerView.m
//  YHImageCarousel
//
//  Created by 峰 on 2017/2/20.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "HomeBannerView.h"
#import "KTPageControl.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "CircularlyView.h"

#define bannerHeight    195.
#define circleRollTime  4.0
#define infoHeight 45.


@interface HomeBannerView ()<CircularlyDelegate>

@property (nonatomic, strong) NSArray  <contents *>*cellInfoArray;
@property (nonatomic, assign) NSUInteger             pageWidth;
@property (nonatomic, assign) NSUInteger             pageHeight;
@property (nonatomic, strong) UILabel               *labelOne;
@property (nonatomic, strong) UILabel               *labelTwo;
@property (nonatomic, strong) KTPageControl         *pageControl;
@property (nonatomic, strong) CircularlyView        *circularView;

@property (nonatomic, strong) UIView                *infoView;
@property (nonatomic, strong) UILabel               *mainLabel;
@property (nonatomic, strong) UILabel               *subLabel;


@end


@implementation HomeBannerView
-(CircularlyView *)circularView{
    if (!_circularView) {
        _circularView = [[CircularlyView alloc]initWithFrame:CGRectMake(0, 0, self.pageWidth, self.pageHeight)];
        _circularView.delegate = self;
        _circularView.rollTime = circleRollTime;
    }
    return _circularView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.circularView];
        [self addSubview:self.infoView];

        [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(infoHeight);
        }];
    }
    return self;
}
-(UIView *)infoView{
    if (!_infoView) {
        _infoView = [UIView new];


        UIImageView *backV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerback"]];
        [_infoView addSubview:backV];

        _mainLabel = [UILabel new];
        [_mainLabel setFont:[UIFont systemFontOfSize:17.]];
        _mainLabel.textColor = [UIColor whiteColor];
        [_infoView addSubview:self.mainLabel];
        _subLabel = [UILabel new];
        [_subLabel setFont:[UIFont systemFontOfSize:13.]];
        _subLabel.textColor = [UIColor lightTextColor];
        [_infoView addSubview:self.subLabel];

        [_infoView addSubview:self.pageControl];

        [backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

        [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(_infoView);
            make.left.mas_equalTo(_infoView).offset(10);
            make.height.mas_equalTo(20);
        }];

        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(_infoView);
            make.left.mas_equalTo(_infoView).offset(10);
            make.height.mas_equalTo(25);
        }];

        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(8);
            make.bottom.mas_equalTo(_infoView).offset(-25);
            make.right.mas_equalTo(_infoView).offset(-10);
        }];

    }
    return _infoView;
}



- (KTPageControl *)pageControl
{
    if (_pageControl == nil) {

        _pageControl = [[KTPageControl alloc] init];
        //有图片显示图片、没图片则显示设置颜色
//       _pageControl.pageIndicatorTintColor =[UIColor whiteColor];
//       _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];

        _pageControl.currentImage =[UIImage imageNamed:@"pagenormal"];
        _pageControl.defaultImage =[UIImage imageNamed:@"pageSelected"];
        _pageControl.pageSize = CGSizeMake(7,7);
        _pageControl.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
    }
    return _pageControl;
}

- (NSUInteger)pageWidth {
    return SCREEN_WIDTH;
}

- (NSUInteger)pageHeight {
    return AutoSize_H_IP6(bannerHeight);
}



-(void)setBannerModel:(homeModel *)bannerModel{
    if (_cellInfoArray) {
        _cellInfoArray=nil;
    }
    _bannerModel = bannerModel;

    if (bannerModel.contents.count>0) {
        _mainLabel.text = bannerModel.contents[0].title;
        _subLabel.text = bannerModel.contents[0].subTitle;
        self.cellInfoArray = bannerModel.contents;
        [_circularView setDataSource:bannerModel.contents];
    }
    if (bannerModel.contents.count>1) {
        _pageControl.numberOfPages = bannerModel.contents.count;
    }

}
- (void)CircularlyDidSelectItemAtIndex:(NSInteger)index{

    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate clickHomeBricksCallBackWith:_bannerModel
                                       andContents:_bannerModel.contents[index]
                                           andType:0];
    }
}

- (void)CircularlyCurrentPageIndex:(NSInteger)pageNumber{

    contents *model = _cellInfoArray [pageNumber];
    if (model.title.length==0&&model.subTitle.length==0) {
        _infoView.hidden = YES;
    }else{
        _infoView.hidden = NO;
        _mainLabel.text = model.title;
        _subLabel.text = model.subTitle;
    }
    _pageControl.currentPage = pageNumber;
}


@end
