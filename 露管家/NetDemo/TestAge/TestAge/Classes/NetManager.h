//
//  NetMananger.h
//  TestAge
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

//1. 搜索图片
+ (void)searchImagesByName:(NSString *)name
              successBlok:(void (^)(NSArray *imgList))successBlock
                 failBlok:(void (^)(NSError *error))failBlock;

//2. 测试年龄
+ (void)testAgeByImageData:(NSData *)imageData
               successBlock:(void (^)(NSDictionary *ageInfos))successBlock
                  failBlock:(void (^)(NSError *error))failBlock;

@end
