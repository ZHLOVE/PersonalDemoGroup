//
//  TaskRequest.m
//  SafeDarkVC
//
//  Created by M on 16/6/20.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "TaskRequest.h"
@interface TaskRequest()


@end

@implementation TaskRequest


- (NSDictionary *)taskRequestDataWithImage:(UIImage *)img
                                   SpecKey:(NSString *)sk
                                BeginColor:(int)bc
                                  EndColor:(int)ec{
    CGFloat quality = 1.0;
    NSData *jpegData = UIImageJPEGRepresentation(img, quality);
    NSString *imageBase64 = [jpegData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dict = @{@"image":imageBase64,@"spec_key":sk,@"begin_color":@(bc),@"end_color":@(ec)};
    
    return dict;
}



@end
