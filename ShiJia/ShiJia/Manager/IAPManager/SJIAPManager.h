//
//  SJIAPManager.h
//  ShiJia
//
//  Created by 峰 on 16/9/9.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@protocol SJIAPManagerDelegate <NSObject>

@optional

- (void)receiveProduct:(SKProduct *)product;

- (void)successfulPurchaseOfId:(NSString *)productId andReceipt:(NSData *)transactionReceipt;

- (void)failedPurchaseWithError:(NSString *)errorDescripiton;



@end

@interface SJIAPManager : NSObject
@property (nonatomic, assign)id<SJIAPManagerDelegate> delegate;


+ (instancetype)sharedManager;

- (BOOL)requestProductWithId:(NSString *)productId;
- (BOOL)purchaseProduct:(SKProduct *)skProduct;
- (BOOL)restorePurchase;

@end
