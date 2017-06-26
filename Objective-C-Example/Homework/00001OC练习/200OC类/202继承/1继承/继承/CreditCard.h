//
//  CreditCard.h
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Card.h"

@interface CreditCard : Card

@property (nonatomic,assign) float creditMoney;

- (instancetype)initWithCredit:(float)credit;

@end
