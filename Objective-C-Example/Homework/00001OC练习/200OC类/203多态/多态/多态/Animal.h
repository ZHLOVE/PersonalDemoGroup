//
//  Animal.h
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animal : NSObject
{
}

// 名字
@property (nonatomic,copy) NSString *name;


// 唱歌
- (void)sing;

@end
