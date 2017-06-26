//
//  Place.h
//  WhereAmI
//
//  Created by niit on 16/4/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Place : NSObject<MKAnnotation>

// 位置信息
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// 标题
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
