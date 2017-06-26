//
//  CollectionViewController.h
//  Flag_CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlagData.h"

@protocol CollectionViewControllerDelegate <NSObject>

- (void)changeFlag:(FlagData *)flag;

@end

@interface CollectionViewController : UICollectionViewController

//2代理人
@property (nonatomic,weak) id <CollectionViewControllerDelegate> delegate;

@end
