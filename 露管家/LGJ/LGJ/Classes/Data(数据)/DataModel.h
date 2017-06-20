//
//  DataModel.h
//  LGJ
//
//  Created by student on 16/5/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic,assign)  int gid;
@property(nonatomic,copy) NSString *name,*image,*counts,*dayFrom,*dayTo,*type;

+ (instancetype)dataWithDict:(NSDictionary *)d;

@end
