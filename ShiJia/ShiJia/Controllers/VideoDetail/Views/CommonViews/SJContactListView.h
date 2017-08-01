//
//  SJContactListView.h
//  ShiJia
//
//  Created by yy on 16/3/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Title view
 */
@interface SJContactListTitleView : UIView

@property (nonatomic,   assign) NSInteger  userCount;
@property (nonatomic, readonly) RACSignal  *selectAllSignal;

@property (nonatomic,   assign) BOOL       selectedAll;

@end


@interface SJContactListView : UIView

@property (nonatomic, strong, readonly) UIButton       *bottomButton;//底部按钮
@property (nonatomic, strong, readonly) NSMutableArray *selectedItems;

@property (nonatomic, strong) NSArray *userList;

@property (nonatomic, readonly) RACSignal *bottomButtonSignal;
@property (nonatomic, strong) RACSubject *selectNumberSubject;
@property (nonatomic, copy) NSString *bottomButtonTitle;
@property (nonatomic, copy) void (^bottomButtonClickBlock)(NSArray *list);
@property (nonatomic, strong) UITextField *fakeText;
/**
 *  底部按钮不可用标志位
 */
@property (nonatomic, assign) BOOL bottomButtonDisabled;

/**
 *  disable好友列表（用于聊天室过滤已加入的好友）
 */
@property (nonatomic, retain) NSArray *disableItems;

- (instancetype)initWithUsers:(NSArray <UserEntity *>*)users;

@end
