//
//  RadionButon.h
//  RadionButon
//
//  Created by niit on 16/4/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadionButonDelegate;

@interface RadionButon : UIButton {
    NSString                        *_groupId;
    BOOL                            _checked;
    id<RadionButonDelegate>       _delegate;
}

@property(nonatomic, assign)id<RadionButonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol RadionButonDelegate <NSObject>

@optional

- (void)didSelectedRadionButon:(RadionButon *)radio groupId:(NSString *)groupId;

@end

