//
//  LoadImages.m
//  验证码练习
//
//  Created by student on 16/3/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "LoadImages.h"

@interface LoadImages ()

//练习视图封装,
/*
 -View    带属性,图片名字,是否被打钩
 |-Button
 |-gouView
 */

@end

@implementation LoadImages

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSMutableArray *)makeBtnImages{
    //存放所有按钮图片
    NSMutableArray *imageBtnViews = [[NSMutableArray alloc]init];
    for (NSString *imageName in self.chineseArray) {
        UIButton *imageBtn = [[UIButton alloc]init];
        [imageBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [imageBtnViews addObject:imageBtn];
    }
    return imageBtnViews;
}


- (void)loadImagesToArray{
    self.chineseArray = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"codes" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in array) {
        if ([tempDict objectForKey:@"images"]) {
            NSArray *tempArray = [[tempDict objectForKey:@"images"] copy];
            for (NSString *tempStr in tempArray) {
                [mArray addObject:tempStr];
            }
        }
    }
    
    self.allImgsArray = [mArray copy];
//    NSLog(@"%@",self.allImgsArray);
    
    //产生8个随机图片放入数组
    for (int i =0; i<8; i++) {
        int index = arc4random()%30;
        NSString *tempStr = mArray[index];
        [self.chineseArray addObject:tempStr];
    }
//    NSLog(@"%@",self.chineseArray);
}



@end
