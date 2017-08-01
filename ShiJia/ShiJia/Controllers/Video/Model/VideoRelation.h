//
//  VideoRelation.h
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseVideo.h"
#import "WatchFocusVideoProgramEntity.h"

/**
 *  相关视频信息
 */
@interface VideoRelation : BaseVideo

//@property (nonatomic, strong) NSString* videoID;
@property (nonatomic, strong) WatchFocusVideoProgramEntity* watchFocusVideoProgramEntity;
@property (nonatomic) NSInteger  index;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
