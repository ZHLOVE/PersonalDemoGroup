//
//  TPAddressBookTableViewCell.h
//  HiTV
//
//  Created by yy on 15/11/11.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//
/// 显示通讯录数据的cell
#import <UIKit/UIKit.h>

@class AddressBook;

extern NSString * const kTPAddressBookTableViewCellIdentifier;

@interface TPAddressBookTableViewCell : UITableViewCell

/**
 *  分享按钮事件block
 */
@property (nonatomic, copy) void(^shareButtonClickBlock)(TPAddressBookTableViewCell *);


/**
 *  显示数据
 *
 *  @param data 
 */
- (void)showData:(AddressBook *)data;

@end
