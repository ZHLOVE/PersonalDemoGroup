//
//  AddNoteViewController.h
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NoteModel.h"

// 定义一个协议
@protocol AddNoteViewControllerDelegate <NSObject>

// 定义一个方法(参数个数根据要传递哪些数据确定)
//- (void)addNoteWithTitle:(NSString *)title andContent:(NSString *)content;

- (void)refresh;

@end

@interface AddNoteViewController : UIViewController

// 代理人
@property (nonatomic,weak) id<AddNoteViewControllerDelegate> delegate;

@property (nonatomic,weak) NoteModel *note;

@end
