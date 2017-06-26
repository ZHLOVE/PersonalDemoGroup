//
//  ViewController_C.h
//  TransValue
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明协议
@protocol ViewController_CDelegate <NSObject>

- (void)transUserName:(NSString *)u andPassword:(NSString *)p andEmail:(NSString *)e;

@end


@interface ViewController_C : UIViewController



@property (nonatomic,weak) id<ViewController_CDelegate> delegate;

@end
