//
//  Zoo.h
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"
@interface Zoo : NSObject
{
    Animal *animals[12];
    
}

// 错的
//@property (nonatomic,strong) Animal *animals[10];

@end
