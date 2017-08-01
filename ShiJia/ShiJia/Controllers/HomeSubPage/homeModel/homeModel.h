//
//  homeModel.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 1 id         String 是 组件id
 2 type       String 是 组件类型（banner/third/category/list/ad）
 3 layout     String 否 类型是list的 时候的布局（4|6|8）
 4 showFresh  String 否 是否显示刷新一批按钮（1：显示，0：不显示）
 5 contents   Array  否 内容数组
 6 separate   String 是 是否有灰色间隔（top，bottom，both，none）
 */
@class contents;
@interface homeModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *layout;
@property (nonatomic, strong) NSString *showFresh;
@property (nonatomic, strong) NSString *separate;
@property (nonatomic, strong) NSArray  <contents *>*contents;

@end
/*
 1	programSeriesId	String	否	节目集id
 2	resourceType	String	是	资源类型（gif/pic）
 3	resourceUrl	    String	是	资源url
 4	actionType	    String	是	动作类型（inner/outter/none）内/外/无
 5	actionUrl	    String	是	动作地址
 6	categoryId		String	否	二级栏目ID
 7	categoryName	String	否	二级栏目名称
 8	title	        String	否	内容标题
 9	subTitle	    String	否	副标题
 10	cornerImg	    String	否	角标
 11	position	    String	否	角标布局（1|2|3|4）
 12 parentCategId   String  否  一级栏目ID
 */
@interface contents : NSObject

@property (nonatomic, strong) NSString *programSeriesId;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, strong) NSString *actionType;
@property (nonatomic, strong) NSString *actionUrl;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *cornerImg;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *parentCategId;
@end


