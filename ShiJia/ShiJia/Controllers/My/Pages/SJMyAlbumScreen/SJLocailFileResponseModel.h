//
//  SJLocailFileResponseModel.h
//  ShiJia
//
//  Created by 峰 on 16/7/8.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  上传到又拍云返回的参数
 */
@interface SJLocailFileResponseModel : NSObject

@property (nonatomic) NSInteger code;
@property (nonatomic,strong ) NSString *message;
@property (nonatomic,strong ) NSString *mimetype;
@property (nonatomic,strong ) NSString *sign;
@property (nonatomic,strong ) NSString *time;
@property (nonatomic,strong ) NSString *url;
@property (nonatomic,strong ) NSString *thumUrl;


@end
