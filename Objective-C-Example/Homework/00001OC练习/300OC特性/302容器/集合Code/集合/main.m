//
//  main.m
//  集合
//
//  Created by niit on 16/1/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
#pragma mark 集合 NSSet
        
#pragma mark -
#pragma mark 创建
        NSSet *set1 =[[NSSet alloc] initWithObjects:@1,@2,@4,nil];
        NSSet *set2 =[[NSSet alloc] initWithObjects:@3,@4,@5,nil];
        NSSet *set3 =[[NSSet alloc] initWithArray:@[@8,@9,@10,@11,@8]];// 用一个数组创建,重复的对象会被去掉
        NSSet *set4 =[[NSSet alloc] initWithSet:set1];
        
        NSLog(@"%@",set1);
        NSLog(@"%@",set2);
        NSLog(@"%@",set3);
        NSLog(@"%@",set4);
        
#pragma mark 集合->数组
        NSArray *all = [set3 allObjects];
        
#pragma mark  当中取一个元素
        NSNumber *n = [set3 anyObject];
        NSLog(@"%@",n);
        
#pragma mark 判断是否包含关系
        BOOL isContain = [set2 containsObject:@3];
        if(isContain)
        {
            NSLog(@"包含3");
        }
        else
        {
            NSLog(@"不包含3");
        }
        
#pragma mark 判断是否有交集(有没有共同元素)
        BOOL isInterset = [set4 intersectsSet:set2];
        NSLog(@"%@",isInterset?@"有交集":@"没有");
        
#pragma mark 判断是否是否一致
        BOOL isSame = [set1 isEqualToSet:set4];
        NSLog(@"%@",isSame?@"一致":@"不一致");
        
#pragma mark 判断是否子集关系
        NSSet *set5 =[[NSSet alloc] initWithObjects:@1,@2,@4,@5,nil];
        BOOL isSub = [set1 isSubsetOfSet:set5];
        NSLog(@"%@",isSub?@"set1 是set5的子集":@"不是");
        
#pragma mark - NSMutableSet 可变集合
        NSMutableSet *mSet1 = [[NSMutableSet alloc] init];
        NSMutableSet *mSet2 = [NSMutableSet set];
        NSMutableSet *mSet3 = [NSMutableSet setWithObjects:@1,@2,@3,nil];
        NSMutableSet *mSet4 = [NSMutableSet setWithObjects:@5,@2,@6,nil];
        
#pragma mark 去掉交集
        //mSet4去掉与mSet3的交集
//        [mSet4 minusSet:mSet3];
//        NSLog(@"mSet4 = %@",mSet4);
        
#pragma mark 得到交集
        //得到mSet4与mSet3交集
//        [mSet4 intersectSet:mSet3];
//        NSLog(@"mSet4 = %@",mSet4);
        
#pragma mark 得到合集
        //
        [mSet4 unionSet:mSet3];
        NSLog(@"mSet4 = %@",mSet4);
        
#pragma mark 添加
        [mSet4 addObject:@5];
        [mSet4 addObjectsFromArray:@[@6,@7]];
        
#pragma mark 移除
        [mSet4 removeObject:@5];
        [mSet4 removeAllObjects];// 移除所有对象
        
#pragma mark - 练习
        //1
        //语文补考名单:@"王鹏" @"王小明" @"比尔盖茨" @"乔布斯" @“奥巴马”
        //数学补考名单:@"比尔盖茨" @"李亚鹏" @"王小明" @"库克" @"奥巴马"
        //打印输出所有要补考人员名单
        //打印输出补考两门人员的名单
        
    }
    return 0;
}
