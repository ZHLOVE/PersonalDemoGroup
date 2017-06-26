//
//  ViewController.h
//  DWMenus
//
//  Created by Dwang on 16/4/27.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWDelegateIndex <NSObject>

- (void) dwDelegateIndex:(NSIndexPath *)index;

@end

@interface DWViewController : UIViewController

@property (weak, nonatomic) id<DWDelegateIndex> delegate;


@end

