//
//  Dog.h
//  练习2
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "def.h"
@class Master;

@protocol DogDelegate <NSObject>

- (void)feedTheDog;

@end

@interface Dog : NSObject

@property(nonatomic,copy)NSString *firstName,*lastName,*fullName;
@property(nonatomic,assign) NSInteger hungry;
@property(nonatomic,assign) BOOL die;
@property(nonatomic,weak)Master *myMaster;
@property (nonatomic,weak)NSTimer *time; //定时器
@property(nonatomic,weak) id<DogDelegate> delegate;

- (void)setFirstName:(NSString *)firstName;
- (NSString *)lastName;
- (NSString *)fullName;



@end
