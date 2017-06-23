//
//  YDGLOperationBlendNode.h
//  YDGLOperationKit
//
//  Created by 辉泽许 on 16/4/12.
//  Copyright © 2016年 yifan. All rights reserved.
//

#import "YDGLOperationNode.h"
/**
 *  @author 9527, 16-04-16 14:37:00
 *
 *  use glBlend to blend the dependency node content
 *
 *  @since 1.0.0
 */
@interface YDGLOperationBlendNode : YDGLOperationNode

@property(nonatomic,assign)float opaticy;//alpha 0.0~1.0

@property(nonatomic,assign)CGRect frame;

@property(nonatomic,assign)GLKMatrix4 transform;//frame center as (0,0,0)

@property(nonatomic,assign,nullable)YDGLOperationBlendNode* superNode;

-(void)addSubNode:(YDGLOperationBlendNode*_Nonnull)subNode;

@end

