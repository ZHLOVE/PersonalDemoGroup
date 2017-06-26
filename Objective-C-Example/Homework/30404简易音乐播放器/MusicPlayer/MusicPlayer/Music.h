//
//  Music.h
//  MusicPlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
@property(nonatomic,copy)NSString *name,*filename,*lrcname,*singer,*singerIcon,*icon;

+(instancetype)dataWithDict:(NSDictionary *)dict;

@end
