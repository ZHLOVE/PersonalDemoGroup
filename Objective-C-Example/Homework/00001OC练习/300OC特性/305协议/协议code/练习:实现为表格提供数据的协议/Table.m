//
//  Table.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Table.h"

@implementation Table

- (void)print
{
    NSString *title = [self.delegate tableTitle];
    NSArray *arr = [self.delegate tableContent];
    int maxLength = title.length;
    for(NSString *tmp in arr)
    {
        if(tmp.length>maxLength)
        {
            maxLength = tmp.length;
        }
    }
    [self printNStar:maxLength];
    [self printContent:title andMaxLength:maxLength];
    [self printNStar:maxLength];
    for(NSString *s in arr)
    {
        [self printContent:s andMaxLength:maxLength];
    }
    [self printNStar:maxLength];

}

- (void)printNStar:(int)n
{
    NSMutableString *str = [NSMutableString string];
    for (int i=0; i<n*2; i++)
    {
        [str appendString:@"*"];
    }
    NSLog(@"%@",str);
}

- (void)printContent:(NSString *)s andMaxLength:(int)length
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"*"];
    [str appendString:s];
    NSLog(@"%@",str);
}

- (BOOL)isASC:(NSString *)s
{
   const char *str = [s UTF8String];
    if(strlen(str)==2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
