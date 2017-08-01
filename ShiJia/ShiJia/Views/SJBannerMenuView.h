//
//  SJBannerMenuView.h
//  ShiJia
//
//  Created by Jian Huang on 8/25/16.
//  Copyright © 2016 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilePath : NSObject

+ (NSString *)getFilePath:(NSString *)fileNameAndType;

@end

@interface BannerMenuView : UIView

/*
 *frame设置浮标位置及长宽
 *nWidth设置展出后增加的菜单宽带，可以动态计算传值
 */
- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth;

@end
