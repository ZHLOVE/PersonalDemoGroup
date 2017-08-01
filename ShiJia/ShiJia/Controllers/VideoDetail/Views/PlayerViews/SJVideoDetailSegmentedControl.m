//
//  SJVideoDetailSegmentedControl.m
//  ShiJia
//
//  Created by yy on 16/3/10.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJVideoDetailSegmentedControl.h"
#import "SJLoginViewController.h"

NSString * const kSJVideoDetailSegmentedControlItemTitleKey = @"SJVideoDetailSegmentedControlItemTitleKey";
NSString * const kSJVideoDetailSegmentedControlItemBadgeKey = @"SJVideoDetailSegmentedControlItemBadgeKey";

@interface SJVideoDetailSegmentedControlItem ()

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UILabel     *label;
@property (nonatomic, strong) UILabel     *badgeLabel;
@property (nonatomic, strong) UIButton    *button;

@end

@implementation SJVideoDetailSegmentedControlItem

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 背景
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backImgView];
        
        // 标题
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:16.0];
        _label.textColor = [UIColor lightGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        // 标记
        _badgeLabel = [[UILabel alloc] init];
//        _badgeLabel.text = @"14";
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.font = [UIFont systemFontOfSize:12.0];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_badgeLabel];
        
        // 按钮
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backImgView.frame = self.bounds;
    _button.frame = self.bounds;
    
    // 计算显示文字需要的rect
    CGRect rect = [_label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:_label.font,NSFontAttributeName, nil] context:nil];
   
    // 设置label frame，居中显示
    _label.frame = CGRectMake((CGRectGetWidth(self.frame)-rect.size.width)/2.0, 0, rect.size.width, CGRectGetHeight(self.frame));
    
    // 计算显示标记需要的rect
    CGRect badgeRect = [_badgeLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:_label.font,NSFontAttributeName, nil] context:nil];
    
    // 设置标记labelframe，位于标题label右上角
    _badgeLabel.frame = CGRectMake(_label.frame.size.width+_label.frame.origin.x , _label.frame.origin.y + badgeRect.size.width / 4.0, badgeRect.size.width, badgeRect.size.width);
    _badgeLabel.layer.borderColor = [UIColor redColor].CGColor;
    _badgeLabel.layer.cornerRadius = badgeRect.size.width / 2.0;
    _badgeLabel.layer.masksToBounds = YES;
    
}

#pragma mark - Event
- (void)buttonClicked:(id)sender
{
//    if (!self.selected) {
//        self.selected = !self.selected;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
//    }
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
   
    if (selected) {
        _label.textColor = kColorBlueTheme;
    }
    else{
        _label.textColor = [UIColor lightGrayColor];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = _title;
 
    [self setNeedsLayout];
    
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    _badgeLabel.text = [NSString stringWithFormat:@"%zd",_badge];
   
    if (badge > 0) {
        _badgeLabel.hidden = NO;
    }
    else{
        _badgeLabel.hidden = YES;
    }
    
}

@end

static CGFloat kLeftPadding      = 10.0;
static CGFloat kTrackImageHeight = 3.0;
static CGFloat kLineImageHeight  = 1.0;

@interface SJVideoDetailSegmentedControl ()

@property (nonatomic, strong) UIImageView    *lineImgView;
@property (nonatomic, strong) UIImageView    *trackImgView;
@property (nonatomic, strong) NSMutableArray *subviews;


@end

@implementation SJVideoDetailSegmentedControl

#pragma mark - Lifecycle
- (instancetype)initWithItems:(NSArray *)array;
{
    self = [super init];
    if (self) {
        
        _items = [NSArray arrayWithArray:array];
        _subviews = [[NSMutableArray alloc] init];

        [self setupSubviews];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = _items.count > 0 ? CGRectGetWidth(self.frame)/(_items.count*1.0) : CGRectGetWidth(self.frame);
   
    for (int i = 0; i < _subviews.count; i ++) {
        
        SJVideoDetailSegmentedControlItem *item = [_subviews objectAtIndex:i];
        item.frame = CGRectMake(i*width, 0, width, CGRectGetHeight(self.frame));
    }
    
    _lineImgView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kLineImageHeight, CGRectGetWidth(self.frame), kLineImageHeight);
    
    _trackImgView.frame = CGRectMake(_selectedSegmentIndex * width + kLeftPadding, self.frame.size.height - kTrackImageHeight, width - kLeftPadding * 2, kTrackImageHeight);
}

#pragma mark - Event
- (void)itemValueChanged:(SJVideoDetailSegmentedControlItem *)sender
{
    if (sender.tag > 0 && ![HiTVGlobals sharedInstance].isLogin && self.activeController) {
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.activeController presentViewController:sjVC animated:YES completion:nil];
        return;
    }
    
//    for (int i = 0; i < _subviews.count; i ++) {
//       SJVideoDetailSegmentedControlItem *item = [_subviews objectAtIndex:i];
//        if (i != sender.tag) {
//            
//            item.selected = NO;
//        }
//        else{
//            item.selected = YES;
//        }
//    }
    self.selectedSegmentIndex = sender.tag;
    
//    CGFloat width = self.frame.size.width / _items.count;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    _trackImgView.frame = CGRectMake(sender.tag * width + kLeftPadding, _trackImgView.frame.origin.y, _trackImgView.frame.size.width, _trackImgView.frame.size.height);
//    [UIView commitAnimations];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Subviews
- (void)setupSubviews
{
    for (UIView *subview in _subviews) {
        [subview removeFromSuperview];
    }
    
    // 加载 子试图
    for (int  i = 0; i < _items.count; i++) {
        
        id obj = [_items objectAtIndex:i];
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            NSString *text = (NSString *)obj;
            
            SJVideoDetailSegmentedControlItem *item = [[SJVideoDetailSegmentedControlItem alloc] init];
            item.tag = i;
            item.title = text;
            
            if (i == 0) {
                item.badge = 0;
                item.selected = YES;
            }
            
            [item addTarget:self action:@selector(itemValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:item];
            [_subviews addObject:item];
            
            
        }
        else{
            
        }
    }
    
    // 分割线
    _lineImgView = [[UIImageView alloc] init];
    _lineImgView.backgroundColor = kColorLightGrayBackground;
    [_lineImgView removeFromSuperview];
    [self addSubview:_lineImgView];
    
    // 当前选中标识view
    _trackImgView = [[UIImageView alloc] init];
    _trackImgView.backgroundColor = kColorBlueTheme;
    [_trackImgView removeFromSuperview];
    [self addSubview:_trackImgView];
}

#pragma mark - Setter
- (void)setItems:(NSArray *)items
{
    _items = items;
    [_subviews removeAllObjects];
    _subviews = [NSMutableArray array];
    [self setupSubviews];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    
    for (int i = 0; i < _subviews.count; i ++) {
        SJVideoDetailSegmentedControlItem *item = [_subviews objectAtIndex:i];
        if (i != selectedSegmentIndex) {
            
            item.selected = NO;
        }
        else{
            item.selected = YES;
        }
    }
    _selectedSegmentIndex = selectedSegmentIndex;
    
    CGFloat width = self.frame.size.width / _items.count;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _trackImgView.frame = CGRectMake(selectedSegmentIndex * width + kLeftPadding, _trackImgView.frame.origin.y, _trackImgView.frame.size.width, _trackImgView.frame.size.height);
    [UIView commitAnimations];
    
    //[self sendActionsForControlEvents:UIControlEventValueChanged];
    
    
}
@end
