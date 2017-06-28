//
//  UINavigationController+Transparent.h
//  MqlNavi
//
//  Created by MBP on 2017/4/14.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transparent)<UINavigationBarDelegate,UINavigationControllerDelegate>
/**
 Change NaviBar's Aplha
 */
@property (copy, nonatomic) NSString *navBarBgAlpha;



/**
 set NavigationController Transparent
 */
- (void)setNeedsNavigationBackground:(CGFloat)alpha;

@end
