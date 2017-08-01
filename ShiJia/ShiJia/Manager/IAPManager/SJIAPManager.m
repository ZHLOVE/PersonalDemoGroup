//
//  SJIAPManager.m
//  ShiJia
//
//  Created by 峰 on 16/9/9.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJIAPManager.h"

@interface SJIAPManager ()<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    SKProduct *myProduct;
}


@end

@implementation SJIAPManager

+ (instancetype)sharedManager {
    
    static SJIAPManager *iapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iapManager = [SJIAPManager new];
    });
    
    return iapManager;
}


/** TODO:请求商品*/
- (BOOL)requestProductWithId:(NSString *)productId {

    if (productId.length > 0) {
        productId = [NSString stringWithFormat:@"%@%@",APPStroreID,productId];
        DDLogInfo(@"请求商品: %@", productId);
        SKProductsRequest *productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productId]];
        productRequest.delegate = self;
        [productRequest start];
        return YES;
    } else {
        DDLogInfo(@"商品ID为空");
//        [self failedTransaction:@"商品ID为空"];
    }
    return NO;
}

/** TODO:购买商品*/
- (BOOL)purchaseProduct:(SKProduct *)skProduct {
    
    if (skProduct != nil) {
        if ([SKPaymentQueue canMakePayments]) {
            SKPayment *payment = [SKPayment paymentWithProduct:skProduct];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            return YES;
        } else {
            DDLogError(@"失败，用户禁止应用内付费购买.");
        }
    }
    return NO;
}

/** TODO:非消耗品恢复*/
- (BOOL)restorePurchase {
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
        return YES;
    } else {
        DDLogError(@"失败,用户禁止应用内付费购买.");
    }
    return NO;
}


#pragma mark - ****************  SKProductsRequest Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *myProductArray = response.products;
    if (myProductArray.count > 0) {
        myProduct = [myProductArray objectAtIndex:0];
        [_delegate receiveProduct:myProduct];
    } else {
        DDLogError(@"无法获取产品信息，购买失败。");
        [_delegate receiveProduct:myProduct];
    }
}

#pragma mark - ****************  SKPaymentTransactionObserver Delegate

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                DDLogInfo(@"商品:%@被添加进购买列表",myProduct.localizedTitle);
                
                break;
            case SKPaymentTransactionStatePurchased://交易成功
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已购买过该商品

                break;
            case SKPaymentTransactionStateDeferred://交易延迟

                break;
            default:
                break;
        }
    }
}
#pragma mark - ****************  Private Methods
//TODO: 把transaction 存入本地沙盒
//TODO: 当和服务器验证只有将本地的移除
//TODO: 如果发起验证时候发现有值的话
//!!!:
//???: 记录内容？ 用户？ 何时验证？


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    [_delegate successfulPurchaseOfId:transaction.payment.productIdentifier andReceipt:receiptData];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
//    if (transaction.error.code != SKErrorPaymentCancelled && transaction.error.code != SKErrorUnknown) {
//        [_delegate failedPurchaseWithError:transaction.error.localizedDescription];
//    }
//    if (transaction.error.code==SKErrorUnknown) {
//        [_delegate failedPurchaseWithError:transaction.error.localizedDescription];
//    }
//    if (transaction.error.code==SKErrorPaymentCancelled) {
        [_delegate failedPurchaseWithError:transaction.error.localizedDescription];
//    }

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
