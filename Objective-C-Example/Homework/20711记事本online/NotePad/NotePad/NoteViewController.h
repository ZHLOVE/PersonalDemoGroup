//
//  NoteViewController.h
//  NotePad
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoteData.h"
@interface NoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,weak) NoteData *noteData;

@end
