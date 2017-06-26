//
//  NoteData.h
//  NotePad
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteData : NSObject

@property(nonatomic,copy)NSString *ID,*CDate,*Content;

- (instancetype)initWithDict:(NSDictionary *)dict;


+ (instancetype)dataWithDict:(NSDictionary *)d;
@end
