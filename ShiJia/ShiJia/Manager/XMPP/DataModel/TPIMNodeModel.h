//
//  TPIMNodeModel.h
//  HiTV
//
//  Created by yy on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSXMLElement+XMPP.h"

/**
 *  xmpp 用户信息
 */
@interface TPIMNodeModel : NSObject

/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  xmpp jid
 */
@property (nonatomic, copy) NSString *jid;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;


/**
 *  用xml初始化
 *
 *  @param element xml
 *
 *  @return 返回TPIMNodeModel
 */
- (instancetype)initWithElement:(NSXMLElement *)element;

@end
