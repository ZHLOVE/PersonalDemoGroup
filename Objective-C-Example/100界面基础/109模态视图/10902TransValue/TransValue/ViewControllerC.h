//
//  ViewControllerC.h
//  TransValue
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

// 声明协议
@protocol ViewControllerCDellegate <NSObject>

// 注意:参数类型取决于你要传递多少数据给代理人
- (void)transUserName:(NSString *)u andPassword:(NSString *)p andEmail:(NSString *)e;

@end

@interface ViewControllerC : UIViewController

// 代理人是谁?
@property (nonatomic,weak) id<ViewControllerCDellegate> delegate;

@end
