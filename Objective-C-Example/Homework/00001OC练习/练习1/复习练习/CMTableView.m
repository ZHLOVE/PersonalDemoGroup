//
//  CMTableView.m
//  复习练习
//
//  Created by student on 16/3/11.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CMTableView.h"

@implementation CMTableView



- (void)show{
    
    for (int i=0;i<self.sectionArray.count;i++) {
        NSLog(@"*****显示*****");
        NSLog(@"*段头:%@*",self.sectionArray[i]);
        NSLog(@"*****显示*****");
            for (int j=i*4;j<(i+1)*4;j++) {
                NSLog(@"%@",self.dataSource.teamNames[j]);
            }
    }

}

- (NSArray *)sectionArray{
    return  self.dataSource.groupNames;
}

- (NSArray *)rowArray{
    return self.dataSource.teamNames;
}

@end
