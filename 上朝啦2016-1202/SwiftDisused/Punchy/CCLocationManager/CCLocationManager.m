//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by WangZeKeJi on 14-12-10.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//


#import "CCLocationManager.h"

@interface CCLocationManager () {
    CLLocationManager *_manager;
}

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

//EyreFree
@property (nonatomic, strong) NSStringBlock shengBlock;
@property (nonatomic, strong) NSStringBlock shiBlock;

@end

@implementation CCLocationManager

+ (CCLocationManager *)shareLocation {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress = [standard objectForKey:CCLastAddress];
        
        //EyreFree
        self.lastSheng = [standard objectForKey:CCLastSheng];
        self.lastShi = [standard objectForKey:CCLastShi];
    }
    return self;
}

//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock {
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock {
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock {
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

//获取省市
- (void) getCity:(NSStringBlock)cityBlock {
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

//获取经纬度和省市
- (void) getLocation:(LocationBlock) locaiontBlock
            AndSheng:(NSStringBlock) shengBlock
              AndShi:(NSStringBlock) shiBlock
       AndPermission:(NSStringBlock) permission {
    self.locationBlock = [locaiontBlock copy];
    self.shengBlock = [shengBlock copy];
    self.shiBlock = [shiBlock copy];
    permission([self startLocation] ? @"true" : @"false");
}

//- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
//{
//    self.cityBlock = [cityBlock copy];
//    self.errorBlock = [errorBlock copy];
//    [self startLocation];
//}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _lastCity = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
            [standard setObject:_lastCity forKey:CCLastCity];//省市地址
            
            _lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];//详细地址
            
            //EyreFree
            _lastSheng = placemark.administrativeArea;
            [standard setObject:_lastSheng forKey:CCLastSheng];//省
            
            _lastShi = placemark.locality;
            [standard setObject:_lastShi forKey:CCLastShi];//市
        }
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
        
        //EyreFree
        if (_shengBlock) {
            _shengBlock(_lastSheng);
            _shengBlock = nil;
        }
        if (_shiBlock) {
            _shiBlock(_lastShi);
            _shiBlock = nil;
        }
    }];
    
    _lastCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude ,newLocation.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    //NSLog(@"%f--%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    [standard setObject:@(newLocation.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(newLocation.coordinate.longitude) forKey:CCLastLongitude];
    
    [manager stopUpdatingLocation];
}

-(BOOL)startLocation {
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestWhenInUseAuthorization];
        _manager.distanceFilter=100;
        [_manager startUpdatingLocation];
        return true;
    } else {
        NSLog(@"无定位权限");
        return false;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self stopLocation];
}

-(void)stopLocation {
    _manager = nil;
}

@end
