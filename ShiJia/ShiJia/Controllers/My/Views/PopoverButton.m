//
//  PopoverButton.m
//  TakeoutUserApp
//
//  Created by iss on 14-8-25.
//  Copyright (c) 2014年 YouYan. All rights reserved.
//

#import "PopoverButton.h"
#import "PopoverView.h"
#import "HiTVDeviceInfo.h"

CGFloat const ArrowImgViewWidth = 25.0;
CGFloat const ArrowImgViewHeight = 25.0;
CGFloat const Distance = 2.0;

#define Navigation_Bar_Height ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? 64 : 44)
#define Screen_Width  CGRectGetWidth([[UIScreen mainScreen] applicationFrame])

@interface PopoverButton ()<PopoverViewDelegate>

@property (nonatomic, retain) PopoverView *view;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *arrowImgView;
@property (nonatomic, retain) UIImageView *iconImgView;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, assign) BOOL showPopView;


@end

@implementation PopoverButton

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubviews];
    self.upArrowImage = [UIImage imageNamed:@"remote_up_arrow_btn"];
    self.downArrowImage = [UIImage imageNamed:@"remote_down_arrow_btn"];
}

#pragma mark - subviews
- (void)setupSubviews
{
    
    //标题
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor blackColor];
    [self addSubview:self.label];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    //标题前的图标
    self.iconImgView = [[UIImageView alloc] init];
    self.iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImgView.clipsToBounds = NO;
    self.iconImgView.image = [UIImage imageNamed:@"remote_box_samll"];
    [self addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.label.mas_left).with.offset(-2);
        make.centerY.equalTo(self).with.offset(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    //标题后的箭头
    self.arrowImgView = [[UIImageView alloc] init];
    self.arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.arrowImgView];
    [self.arrowImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(0);
        make.left.equalTo(self.label.mas_right).with.offset(2);
        make.height.mas_equalTo(ArrowImgViewHeight);
        make.width.mas_equalTo(ArrowImgViewWidth);
    }];
    
    //按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.showsTouchWhenHighlighted = NO;
    [self addSubview:self.button];
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    [self bringSubviewToFront:self.button];
    
    self.showPopView = NO;
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.frame.size.width > 0) {
                
        if ([self.superview isKindOfClass:[UINavigationBar class]]) {
            self.view.originY = Navigation_Bar_Height;
            
        }
        else{
            self.view.originY = self.frame.origin.y+CGRectGetHeight(self.frame);//+Navigation_Bar_Height
        }
    }
}

#pragma mark - button click
- (void)buttonClicked:(id)sender
{
    if (self.buttonEventType == ButtonEventType_Custom) {
        //用户自定义事件
        if (self.buttonClickEventBlock) {
            self.buttonClickEventBlock();
        }
    }
    else{
        //显示列表事件
        if (self.showPopView)
        {
            //隐藏列表
            self.arrowImgView.image = self.downArrowImage;
            [self.view hidePopoverView];
        }
        else
        {
            //显示列表
            if (self.upArrowImage == nil) {
                self.arrowImgView.image = self.downArrowImage;
            }
            else{
                self.arrowImgView.image = self.upArrowImage;
            }
            
            [self.view showPopoverView];
        }
        self.showPopView = !self.showPopView;
    }
    
}

#pragma mark - property
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
    CGRect bounds = CGRectZero;
    
    bounds = [title boundingRectWithSize:CGSizeMake(self.label.frame.size.width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,self.label.textColor,NSForegroundColorAttributeName, nil] context:nil];
    
    CGFloat width = CGRectGetWidth(bounds);
    if (width < self.frame.size.width) {
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.centerX.equalTo(self.mas_centerX).with.offset(-ArrowImgViewWidth/2.0);
        }];
    }
    else{
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.centerX.equalTo(self.mas_centerX).with.offset(self.frame.size.width/2.0-ArrowImgViewWidth/2.0);
        }];
    }
}

- (void)setList:(NSArray *)list
{
    _list = list;
    if (self.view == nil)
    {
        self.view = [[PopoverView alloc] initWithItems:list];
        self.view.delegate = self;
    }
    
    self.view.list = list;
}

- (void)setSelectedDevice:(HiTVDeviceInfo *)selectedDevice
{
    _selectedDevice = selectedDevice;
    if (selectedDevice) {
        self.view.selectedDevice = selectedDevice;
    }
}

- (void)setSelectState:(PopoverButtonSelectState)selectState
{
    _selectState = selectState;
    switch (selectState) {
        case PopoverButtonSelectState_SelectNone:
            self.view.selectState = PopoverViewSelectState_SelectNone;
            break;
        case PopoverButtonSelectState_SelectAll:
            self.view.selectState = PopoverButtonSelectState_SelectAll;
            break;
        case PopoverButtonSelectState_Custom:
            self.view.selectState = PopoverButtonSelectState_Custom;
            break;
        default:
            break;
    }
    
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.label.textColor = textColor;
    if (self.title.length == 0 && self.list.count != 0) {
        self.title = [self.list firstObject];
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.label.font = font;
}

- (void)setUpArrowImage:(UIImage *)upArrowImage
{
    _upArrowImage = upArrowImage;
    if (self.showPopView) {
        self.arrowImgView.image = upArrowImage;
    }
}

- (void)setDownArrowImage:(UIImage *)downArrowImage
{
    _downArrowImage = downArrowImage;
    if (!self.showPopView) {
        self.arrowImgView.image = downArrowImage;
    }
    
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    if (self.iconImgView == nil) {
        self.iconImgView = [[UIImageView alloc] init];
        self.iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImgView.clipsToBounds = NO;
        [self addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.label).with.offset(0);
            make.centerY.equalTo(self).with.offset(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
    
    }
    self.iconImgView.image = iconImage;
    
}

#pragma mark - popover view
- (void)hidePopoverView
{
    self.showPopView = !self.showPopView;
    self.arrowImgView.image = self.downArrowImage;
}

- (void)popoverView:(PopoverView *)sender didSelectCellAtIndex:(NSInteger)index
{

    [self buttonClicked:nil];
    if ([self.delegate respondsToSelector:@selector(popoverButton:didSelectItemAtIndex:)]) {
        [self.delegate popoverButton:self didSelectItemAtIndex:index];
    }
}


@end


