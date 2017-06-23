//
//  NoteModel.h
//  NetNote
//
//  Created by niit on 16/4/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

//[{"ID":3593,"CDate":"2015-03-25","Content":"123123"
@property (nonatomic,copy) NSString *ID,*CDate,*Content;

- (instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)noteWithDict:(NSDictionary *)dict;
@end
