//
//  YYSwitch.m
//  ShiJia
//
//  Created by yy on 16/3/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJSwitch.h"

static CGFloat kThumbInnerPadding = 1.0;

@interface SJSwitch ()

@property (nonatomic, strong) ASImageNode  *backgroundNode;
@property (nonatomic, strong) ASImageNode  *thumbNode;
@property (nonatomic, strong) ASTextNode   *textNode;
@property (nonatomic, strong) ASButtonNode *buttonNode;
@property (nonatomic, assign) BOOL          isAnimated;

@end

@implementation SJSwitch

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
   
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        _on = YES;
        _onTintColor = RGB(156, 204, 101, 1);
        _tintColor = [UIColor lightGrayColor];
        _thumbTintColor = [UIColor whiteColor];
        
        // 背景
        _backgroundNode = [[ASImageNode alloc] init];
        _backgroundNode.shadowColor = [UIColor blackColor].CGColor;
        _backgroundNode.shadowOpacity = 0.6;
        _backgroundNode.shadowOffset = CGSizeMake(0, 1);
        _backgroundNode.contentMode = UIViewContentModeCenter;
        [self addSubnode:_backgroundNode];
        
        // 滑块
        _thumbNode = [[ASImageNode alloc] init];
        [self addSubnode:_thumbNode];
        
        // 标题
        _textNode = [[ASTextNode alloc] init];
        _textNode.flexShrink = NO;
        _textNode.truncationMode = NSLineBreakByTruncatingTail;
        _textNode.maximumNumberOfLines = 1;
        _textNode.alignSelf = ASStackLayoutAlignSelfCenter;
        [self addSubnode:_textNode];
        
        // 按钮
        _buttonNode = [[ASButtonNode alloc] init];
        _buttonNode.alpha = 0.5;
        [_buttonNode addTarget:self action:@selector(buttonNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_buttonNode];
        
    }
    return self;

}

- (void)layout
{
    [super layout];
    
    _backgroundNode.frame = self.bounds;
    _buttonNode.frame = self.bounds;
    
    
    CGSize textSize = [_textNode measure:self.frame.size];
    
    CGFloat thumbWidth = self.frame.size.height - kThumbInnerPadding * 2;
    
    
    if (self.frame.size.width > 0) {
        
        _backgroundNode.layer.cornerRadius = self.frame.size.height / 2.0;
        _backgroundNode.layer.masksToBounds = YES;
       
        _thumbNode.layer.cornerRadius = thumbWidth / 2.0;
        _thumbNode.layer.masksToBounds = YES;
        _thumbNode.backgroundColor = _thumbTintColor;
        _thumbNode.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _thumbNode.layer.shadowOffset = CGSizeMake(-1, -1);
        _thumbNode.layer.shadowOpacity = 0.6;
        
    }
    
    
    if (_on) {
        
        // 开
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        _thumbNode.frame = CGRectMake(self.frame.size.width - self.frame.size.height, kThumbInnerPadding, thumbWidth, thumbWidth);
        if (_onImage != nil) {
            _backgroundNode.image = _onImage;
        }
        else{
            _backgroundNode.backgroundColor = _onTintColor;
        }
        
        [UIView commitAnimations];
        
        // 标题位置
        CGFloat originx = (self.frame.size.width - kThumbInnerPadding - thumbWidth - self.frame.size.height / 2.0 - textSize.width) / 2.0 + self.frame.size.height / 2.0;
        CGFloat originy = (self.frame.size.height - textSize.height) / 2.0;
        
        _textNode.frame = CGRectMake(originx, originy, self.frame.size.width - thumbWidth / 2.0 - thumbWidth - kThumbInnerPadding, self.frame.size.height);
        if (_onText.length > 0) {
            _textNode.attributedString = [[NSAttributedString alloc] initWithString:_onText attributes:[self textAttributes]];
        }
        
    }
    else{
        
        // 关
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        _thumbNode.frame = CGRectMake(kThumbInnerPadding, kThumbInnerPadding, thumbWidth, thumbWidth);
        
        if (_offImage) {
            _backgroundNode.image = _offImage;
        }
        else{
            _backgroundNode.backgroundColor = _tintColor;
        }
        
        [UIView commitAnimations];
        
        // 标题位置
        CGFloat originx = (self.frame.size.width - kThumbInnerPadding - thumbWidth - self.frame.size.height / 2.0 - textSize.width) / 2.0 + kThumbInnerPadding + thumbWidth;
        CGFloat originy = (self.frame.size.height - textSize.height) / 2.0;
        
        _textNode.frame = CGRectMake(originx, originy,textSize.width, textSize.height);
        
        if (_onText.length > 0) {
            _textNode.attributedString = [[NSAttributedString alloc] initWithString:_offText attributes:[self textAttributes]];
        }
        
    }
    
}

#pragma mark - Event
- (void)buttonNodeClicked:(id)sender
{
    if (!self.isEnabled) {
        return;
    }
    
    if (!self.changeValueAfterAction) {
        self.on = !self.on;
        [self setNeedsLayout];
    }
    [self sendActionsForControlEvents:ASControlNodeEventTouchUpInside withEvent:nil];
}

#pragma mark - Setter
- (void)setOn:(BOOL)on
{
    [self setOn:on animated:YES];

}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    _on = on;
    
    _isAnimated = animated;
    [self setNeedsLayout];
}

#pragma mark - Private
- (NSDictionary *)textAttributes
{
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:13.0],
             NSForegroundColorAttributeName: [UIColor whiteColor]
             };
}

@end
