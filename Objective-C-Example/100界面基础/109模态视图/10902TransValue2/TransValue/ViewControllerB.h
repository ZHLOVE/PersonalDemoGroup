//
//  ViewControllerB.h
//  TransValue
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

// 1. 声明协议
@protocol ViewControllerBDelegate <NSObject>

// 声明方法，要传递回去的数据作为参数
- (void)transBack:(NSString *)str;

@end

@interface ViewControllerB : UIViewController

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


// 2. 定义一个支持协议的代理人
@property (nonatomic,weak) id<ViewControllerBDelegate> delegate;

@end
