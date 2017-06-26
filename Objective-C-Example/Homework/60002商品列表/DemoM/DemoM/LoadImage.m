//
//  LoadImage.m
//  DemoM
//
//  Created by student on 16/2/26.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "LoadImage.h"


static LoadImage *instance = nil;


@interface LoadImage()
//图片name
@property(nonatomic,strong) NSMutableArray *imageNames;
//图片iconName
@property(nonatomic,strong) NSMutableArray *imageIcons;

@end

@implementation LoadImage

//得到单例对象
+ (LoadImage *)sharedLoadImage{
    if (instance == nil) {
        instance = [[LoadImage alloc]init];
    }
    return instance;
}

- (instancetype)init
{
    self.imageNames = [[NSMutableArray alloc]init];
    self.imageIcons = [[NSMutableArray alloc]init];
    self = [super init];
    if (self) {
        //1读plist文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"];
        NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:path];

        for (NSDictionary *tempDict in arrayPlist) {
            //取出图片名字
        
            [self.imageNames addObject:[tempDict objectForKey:@"name"]];
           
            //取出图片
            [self.imageIcons addObject:[tempDict objectForKey:@"icon"]];
        }
    }
    return self;
}

+(NSArray *)imageNames{
    LoadImage *images = [LoadImage sharedLoadImage];
    return images.imageNames;
}

+(NSArray *)imageIcons{
    LoadImage *images = [LoadImage sharedLoadImage];
    return images.imageIcons;
}























@end
