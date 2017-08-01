//
//  SJChatRoomTipCellTableViewCell.m
//  ShiJia
//
//  Created by yy on 16/8/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJChatRoomTipCell.h"

@interface SJChatRoomTipCell ()

@property (nonatomic, strong)  ASTextNode *label;

@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation SJChatRoomTipCell

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
        _tipLabel.font = [UIFont systemFontOfSize:14.0];
        _tipLabel.textColor = [UIColor colorWithHexString:@"9e9e9e"];
//        _tipLabel.layer.cornerRadius = 3.0;
//        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_tipLabel];
    }
    return self;
    
}

- (void)layout
{
    [super layout];
    
    if (_tipLabel.text.length != 0) {
        
        CGRect rect = [_tipLabel.text boundingRectWithSize:CGSizeMake(FLT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_tipLabel.font,NSFontAttributeName, nil] context:nil];
        
        rect.size.width += 10;
        
        if (rect.size.width > self.frame.size.width) {
            rect.size.width = self.frame.size.width;
        }
        _tipLabel.frame = CGRectMake((self.frame.size.width - rect.size.width) / 2.0, 5, rect.size.width, self.frame.size.height - 10);
    }
    
}

#pragma mark - Setter
- (void)setText:(NSString *)text
{
    _text = text;
    if (text.length != 0) {

        _tipLabel.text = text;
        [self setNeedsLayout];
    }
}

@end
