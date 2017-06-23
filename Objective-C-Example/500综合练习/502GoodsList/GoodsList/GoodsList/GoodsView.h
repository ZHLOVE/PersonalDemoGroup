//
//  GoodsView.h
//  GoodsList
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsModel;

@interface GoodsView : UIView

+ (GoodsView *)loadGoodsView;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic,strong) GoodsModel *goodsModel;


@end
