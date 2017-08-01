//
//  BaseVideo.h
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  视频基类
 */
@interface BaseVideo : NSObject<NSCoding>

@property (nonatomic, strong) NSString* videoID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* action;
@property (nonatomic, strong) NSString* director;
@property (nonatomic, strong) NSString* actor;
@property (nonatomic, strong) NSString* actionUrl;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* length;
@property (nonatomic, strong) NSString* psId;


@end
