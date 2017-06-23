//
//  AddNoteViewController.m
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AddNoteViewController.h"

#import "NoteGroup.h"

@interface AddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.note != nil)
    {
        self.textField.text = self.note.title;
        self.contentTextView.text = self.note.content;
    }
}

- (IBAction)saveBtnPressed:(id)sender
{
    // 调用数据层添加数据
    NoteGroup *noteGroup = [NoteGroup sharedNoteGroup];
    if(self.note == nil)
    {
        // 添加
        [noteGroup addNoteWithTitle:self.textField.text andContent:self.contentTextView.text];
    }
    else
    {
        // 修改
        [noteGroup modifyNote:self.note withTitle:self.textField.text andContent:self.contentTextView.text];
    }

    [self.delegate refresh];
    // 回到前一个页面
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancelBtnPressed:(id)sender
{
    // 回到前一个页面
    [self.navigationController popViewControllerAnimated:YES];
}
@end
