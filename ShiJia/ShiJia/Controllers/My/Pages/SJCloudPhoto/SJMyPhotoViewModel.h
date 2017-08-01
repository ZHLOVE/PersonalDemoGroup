//
//  SJMyPhotoViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    LOCAIL=0,
    CLOUD
}Photo_TYPE;//枚举名称

@interface SJMyPhotoViewModel : NSObject
@property (nonatomic, strong) RACSubject *photoModelSubject;

-(void)getGroup;

@end
