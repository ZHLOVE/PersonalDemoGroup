//
//  NetManager.m
//  NetNote
//
//  Created by niit on 16/4/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"


@implementation NetManager

+ (void)requestNoteListSuccessBlock:(void (^)(NSMutableArray *list))successBlock
                          failBlock:(void (^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:@"http://www.51work6.com/service/mynotes/WebService.php?email=6157500@qq.com&type=JSON&action=query"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"%@",dict);
            if([dict[@"ResultCode"] isEqualToNumber:@0])
            {
                NSArray *arr = dict[@"Record"];
                NSMutableArray *mList = [NSMutableArray array];
                for(NSDictionary *tmpDict in arr)
                {
                    NoteModel *note = [NoteModel noteWithDict:tmpDict];
                    [mList addObject:note];
                }
                successBlock(mList);
            }
//            else if([dict[@"ResultCode"] isEqualToString:@"0"])
//            {
//                successBlock([NSMutableArray array]);
//            }
        }
        else
        {
            failBlock(connectionError);
        }
        
    }];
}

/**
 *  添加
 *
 *  @param node         添加的note信息
 *  @param successBlock 添加成功执行的block
 *  @param failBlock    添加失败执行的block
 */
+ (void)addNote:(NoteModel *)note
   SuccessBlock:(void (^)())successBlock
      failBlock:(void (^)(NSError *error))failBlock
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.51work6.com/service/mynotes/WebService.php?email=6157500@qq.com&type=JSON&action=add&content=%@&date=%@",note.Content,[df stringFromDate:date]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"%@",dict);
            if([dict[@"ResultCode"] isEqualToNumber:@1])
            {
                successBlock();
            }
        }
        else
        {
            failBlock(connectionError);
        }
        
    }];
}

/**
 *  删除
 *
 *  @param ID           要删除的编号
 *  @param successBlock 删除成功执行的block
 *  @param failBlock    删除成功执行的block
 */
+ (void)removeNoteById:(NSString *)ID
          SuccessBlock:(void (^)())successBlock
             failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.51work6.com/service/mynotes/WebService.php?email=6157500@qq.com&type=JSON&action=remove&id=%@",ID];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"%@",dict);
            if([dict[@"ResultCode"] isEqualToNumber:@1])
            {
                successBlock();
            }
        }
        else
        {
            failBlock(connectionError);
        }
        
    }];
}
@end
