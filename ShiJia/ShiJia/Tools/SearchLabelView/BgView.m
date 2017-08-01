//
//  BgView.m
//  标签
//
//  Created by 回忆网络 on 27/6/16.
//  Copyright © 2016年 回忆网络. All rights reserved.
//

#import "BgView.h"
#define WIDTH        [UIScreen mainScreen].bounds.size.width
@implementation BgView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {

    }

    return self;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    _height = 0;
    for (int i=0; i<_array.count; i++)
    {
        NSString *name=_array[i];
        
        static UIButton *beforeBtn=nil;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundColor=[UIColor clearColor];
        
        UIColor *color = RGB(68, 68, 68, 1);
        if (i == 0) {
            color =RGB(243, 59, 25, 1);
        }
        else if(i == 1){
            color =RGB(255, 159, 1, 1);
        }
        else if(i == 2){
            color =RGB(254, 203, 47, 1);
        }
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        CGRect rect=[name boundingRectWithSize:CGSizeMake(WIDTH, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:button.titleLabel.font} context:nil];
        if (i==0)
        {
            button.frame=CGRectMake(10, 30, rect.size.width+15, rect.size.height+15);
            _height = button.frame.origin.y+button.frame.size.height;
        }
        else
        {
            CGFloat leaveWidth=WIDTH-beforeBtn.frame.size.width-beforeBtn.frame.origin.x-20;
            if (leaveWidth>=rect.size.width)
            {
                button.frame=CGRectMake(CGRectGetMaxX(beforeBtn.frame)+10, beforeBtn.frame.origin.y, rect.size.width+15, rect.size.height+15);
                _height = button.frame.origin.y+button.frame.size.height;
            }
            else
            {
                
                button.frame=CGRectMake(10, CGRectGetMaxY(beforeBtn.frame)+20, rect.size.width+15, rect.size.height+15);
                _height = button.frame.origin.y+button.frame.size.height;
            }
            
        }
        button.tag=i;
        button.layer.cornerRadius=15;
        button.clipsToBounds=YES;
        UIColor *borderColor = color;
        if(i > 2){
            borderColor =RGB(204, 204, 204, 1);
        }
        button.layer.borderColor = borderColor.CGColor;
        button.layer.borderWidth = 1.0f;
        [button setTitle:name forState:UIControlStateNormal];
        beforeBtn=button;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    _height += 30;
}
-(void)btnClick:(UIButton *)sender
{
 
    if (self.block)
    {
        self.block(sender,_array[sender.tag]);
    
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
