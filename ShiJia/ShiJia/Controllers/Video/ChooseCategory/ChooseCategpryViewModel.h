//
//  ChooseCategpryViewModel.h
//  ShiJia
//
//  Created by 峰 on 2016/12/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChooseCategoryDelegate.h"
#import "ChooseCategoryModel.h"

@interface ChooseCategpryViewModel : NSObject

@property (nonatomic, weak) id<ChooseCategoryDelegate>delegate;

-(void)ChooseRequestCategory;

-(void)RequestChooseItemData:(NSMutableDictionary *)model;

@end
