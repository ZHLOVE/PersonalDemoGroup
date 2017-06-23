//
//  NoteModel.h
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic,strong) NSDate *time;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)noteWithDict:(NSDictionary *)dict;

@end
