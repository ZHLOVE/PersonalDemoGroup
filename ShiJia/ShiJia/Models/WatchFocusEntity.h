//
//  WatchFocusEntity.h
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

/*
 {"assortId":371,"assortName":"最新","backimg":"http://223.82.250.81:7075/images/ysten/images/lanmudianbo/ZX.png","actionType":"OpenNew","supportOwn":"true","supportSearch":"close","assortList":[{"assortId":371,"assortName":"全部","img":"http://223.82.250.81:7075/images/ysten/images/lanmudianbo/ZX.png","newImg":"","actionType":"OpenNew"},{"assortId":2443,"assortName":"音乐下午茶","img":"null","newImg":"","actionType":"The popularity of TV"},{"assortId":2444,"assortName":"苍穹之下","img":"null","newImg":"","actionType":"OpenNew"},{"assortId":2445,"assortName":"猜你喜欢","img":"null","newImg":"","actionType":"Northwest"},
 */

@protocol WatchFocusEntity <NSObject>


@end
@interface WatchFocusEntity : JSONModel

@property (nonatomic) NSNumber* assortId;
@property (nonatomic, copy) NSString* assortName;
@property (nonatomic, copy) NSString<Optional>* backimg;
@property (nonatomic, copy) NSString<Optional>* img;
@property (nonatomic, copy) NSString* actionType;
@property (nonatomic, strong) NSNumber<Optional>* supportOwn;
@property (nonatomic, copy) NSString<Optional>* supportSearch;
@property (nonatomic, strong) NSArray<WatchFocusEntity, Optional>* assortList;

@end
