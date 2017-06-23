//
//  NoteGroup.m
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NoteGroup.h"

// 存储方式改为plist的方式

static NoteGroup *instance = nil;

@implementation NoteGroup

+ (NoteGroup *)sharedNoteGroup
{
    if(instance == nil)
    {
        instance = [[NoteGroup alloc] init];
    }
    return instance;
}


- (NSMutableArray *)noteList
{
    if(_noteList == nil)
    {
        _noteList = [NSMutableArray array];
     
        // NSUserDefaults方式
//        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
//        NSArray *arr = [d objectForKey:@"noteList"];
//        if(arr != nil)
//        {
//            for (NSDictionary *dict in arr)
//            {
//                NoteModel *n = [NoteModel noteWithDict:dict];
//                [_noteList addObject:n];
//            }
//        }
        
        // plist方式
        NSArray *arr = [NSArray arrayWithContentsOfFile:[self plistPath]];
        for (NSDictionary *dict in arr)
        {
            for (NSDictionary *dict in arr)
            {
                NoteModel *n = [NoteModel noteWithDict:dict];
                [_noteList addObject:n];
            }
        }
        
    }
    return _noteList;
}

- (NSString *)plistPath
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"noteList.plist"];
}

- (void)saveData
{
//    //对象数组 -> 字典数组
    NSMutableArray *mArr = [NSMutableArray array];
    for (NoteModel *m in self.noteList)
    {
        NSDictionary *d  = @{@"title":m.title,@"content":m.content,@"time":m.time};
        [mArr addObject:d];
    }

    // NSUserDefauts方式
//    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
//    [d setObject:mArr forKey:@"noteList"];
//    [d synchronize];
    
    [mArr writeToFile:[self plistPath] atomically:YES];
}


#pragma mark -
- (void)addNoteWithTitle:(NSString *)title andContent:(NSString *)content
{
    NoteModel *m = [[NoteModel alloc] init];
    m.title = title;
    m.content = content;
    m.time = [NSDate date];

    [self.noteList insertObject:m atIndex:0];
    [self saveData];
}

- (void)modifyNote:(NoteModel *)n withTitle:(NSString *)title andContent:(NSString *)content
{
    n.title = title;
    n.content = content;
    
    [self saveData];
}

- (void)removeNoteByIndex:(NSUInteger)index
{
    [self.noteList removeObjectAtIndex:index];
    [self saveData];
}

- (NSMutableArray *)findAll
{
    return self.noteList;
}


@end
