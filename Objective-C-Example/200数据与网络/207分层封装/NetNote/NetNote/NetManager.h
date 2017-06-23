//
//  NetManager.h
//  NetNote
//
//  Created by niit on 16/4/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NoteModel.h"

@interface NetManager : NSObject

/**
 *  查询
 *
 *  @param successBlock 查询成功执行的block
 *  @param failBlock    查询失败执行的block
 */
+ (void)requestNoteListSuccessBlock:(void (^)(NSMutableArray *list))successBlock
                          failBlock:(void (^)(NSError *error))failBlock;

/**
 *  添加
 *
 *  @param node         添加的note信息
 *  @param successBlock 添加成功执行的block
 *  @param failBlock    添加失败执行的block
 */
+ (void)addNote:(NoteModel *)note
   SuccessBlock:(void (^)())successBlock
      failBlock:(void (^)(NSError *error))failBlock;

/**
 *  删除
 *
 *  @param ID           要删除的编号
 *  @param successBlock 删除成功执行的block
 *  @param failBlock    删除成功执行的block
 */
+ (void)removeNoteById:(NSString *)ID
          SuccessBlock:(void (^)())successBlock
             failBlock:(void (^)(NSError *error))failBlock;

@end
