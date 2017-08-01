//
//  SJYueCell.h
//  ShiJia
//
//  Created by yy on 16/6/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSJYueCellIdentifier;

typedef NS_ENUM(NSInteger, SJYueCellStyle){
    
    SJYueCellStyleNormal,
    SJYueCellStyleInvited
    
};//cell样式

@interface SJYueCell : UICollectionViewCell

@property (nonatomic, assign) SJYueCellStyle style;

- (void)showImage:(UIImage *)img name:(NSString *)name;
- (void)showImgUrl:(NSString *)imgUrl name:(NSString *)name;

@end
