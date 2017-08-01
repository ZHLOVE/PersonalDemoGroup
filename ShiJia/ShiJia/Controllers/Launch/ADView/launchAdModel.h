//
//  launchAdModel.h
//  ShiJia
//
//  Created by 峰 on 2017/2/17.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 1	programSeriesId	String	是	节目集id
 2	actionType	    String	是	跳转类型（inner/outter）
 3	actionUrl	    String	是	跳转地址
 4	resourceType	String	是	资源类型（gif/pic）
 5	resourceUrl	    String	是	资源url
 6	timeCount	    String	是	广告时长（单位秒）
 */
@interface launchAdModel : NSObject
@property (nonatomic, strong) NSString *programSeriesId;
@property (nonatomic, strong) NSString *actionType;
@property (nonatomic, strong) NSString *actionUrl;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, strong) NSString *timeCount;
@end
