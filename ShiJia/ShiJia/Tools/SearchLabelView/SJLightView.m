//
//  SJLightView.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLightView.h"

@implementation SJLightView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        
    }
    
    return self;
}
-(UIColor *)curColor{
    UIColor *color = kColorBlueTheme;
    int x = arc4random() % 4;
    if (x == 0) {
        color =RGB(243, 59, 25, 1);
    }
    else if(x == 1){
        color =RGB(255, 159, 1, 1);
    }
    else if(x == 2){
        color =RGB(116, 202, 86, 1);
    }
    return color;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    for (int i=0; i<_array.count; i++)
    {
        NSString *name=_array[i];
        
        static UIButton *beforeBtn=nil;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundColor=[UIColor clearColor];
        UIColor *color = [self curColor];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect rect=[name boundingRectWithSize:CGSizeMake(self.frame.size.width, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        if (i==0)
        {
            button.frame=CGRectMake(10, 30, rect.size.width+15, rect.size.height+15);
        }
        else
        {
            CGFloat leaveWidth=self.frame.size.width-beforeBtn.frame.size.width-beforeBtn.frame.origin.x-20;
            if (leaveWidth>=rect.size.width)
            {
                button.frame=CGRectMake(CGRectGetMaxX(beforeBtn.frame)+10, beforeBtn.frame.origin.y, rect.size.width+15, rect.size.height+15);
            }
            else
            {
                
                button.frame=CGRectMake(10, CGRectGetMaxY(beforeBtn.frame)+20, rect.size.width+15, rect.size.height+15);
            }
            
        }
        button.tag=i;
        button.layer.cornerRadius=17;
        button.clipsToBounds=YES;
        UIColor *borderColor = color;
//        if(i > 2){
//            borderColor =kNavColor;
//        }
        button.layer.borderColor = borderColor.CGColor;
        button.layer.borderWidth = 1.0f;
        [button setTitle:name forState:UIControlStateNormal];
        beforeBtn=button;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
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
