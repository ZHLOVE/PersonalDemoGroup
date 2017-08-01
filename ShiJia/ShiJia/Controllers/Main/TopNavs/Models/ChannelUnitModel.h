//
//  ChannelUnitModel.h
//  V1_Circle
//
//  Created by 刘瑞龙 on 15/11/10.
//  Copyright © 2015年 com.Dmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelUnitModel : NSObject
/*
 *  editAble <1:可编辑 0:不可编辑>
 */
@property (nonatomic, copy) NSString *editAble;
/*
 *  导航icon
 */
@property (nonatomic, copy) NSString *icon;
/*
 *  特殊节目导航icon
 */
@property (nonatomic, copy) NSString *iconSpec;
/*
 *  导航名称
 */
@property (nonatomic, copy) NSString *name;
/*
 *  导航ID
 */
@property (nonatomic, copy) NSString *navigateId;

/*
 *  二级栏目ID
 */
@property (nonatomic, copy) NSString *categoryId;

/*
 *  一级栏目ID
 */
@property (nonatomic, copy) NSString *parentCategId;

/*
 *  动作类型（inner/outter）
 */
@property (nonatomic, copy) NSString *actionType;

/*
 *  外链地址
 */
@property (nonatomic, copy) NSString *actionUrl;

@property (nonatomic, assign) BOOL isTop;

@property (nonatomic, assign) BOOL isLoaded;


- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
