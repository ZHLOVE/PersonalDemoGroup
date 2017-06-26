//
//  Book.h
//  KVCDemo
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
{
//     NSString *bookName;//书名
//     NSString *bookArtist;//作者
}
@property (nonatomic,copy) NSString *bookName;//书名
@property (nonatomic,copy) NSString *bookArtist;//作者
@property (nonatomic,assign) int price;


- (instancetype)initWithDictionary:(NSDictionary *)d;
+ (instancetype)bookWithDictionary:(NSDictionary *)d;

@property (nonatomic,assign) int v1;
@property (nonatomic,assign) int v2;
@property (nonatomic,assign) int v3;
@property (nonatomic,assign) int v4;
@property (nonatomic,assign) int v5;
@property (nonatomic,assign) int v6;
@property (nonatomic,assign) int v7;
@property (nonatomic,assign) int v8;
@property (nonatomic,assign) int v9;
@property (nonatomic,assign) int v10;

@end
