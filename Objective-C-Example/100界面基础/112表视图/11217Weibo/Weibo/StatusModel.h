//
//  StatusModel.h
//  Weibo
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StatusModel : NSObject

@property (nonatomic,copy) NSString *icon,*name,*text,*picture;
@property (nonatomic,assign) BOOL vip;

// 添加一项用来保存单元格的告诉
@property (nonatomic,assign) CGFloat cellHeight;

- (instancetype)initWithDict:(NSDictionary *)d;
+ (instancetype)statusWithDict:(NSDictionary *)d;

+ (NSArray *)statusArr;

@end
