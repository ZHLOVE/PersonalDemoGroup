//
//  AddNoteViewController.m
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AddNoteViewController.h"

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
    if(self.note == nil)
    {
        // 传递给前一个页面
        [self.delegate addNoteWithTitle:self.textField.text  andContent:self.contentTextView.text];
    }
    else
    {
        self.note.title = self.textField.text;
        self.note.content = self.contentTextView.text;
        [self.delegate refresh];
    }
    
    // 回到前一个页面
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancelBtnPressed:(id)sender
{
    // 回到前一个页面
    [self.navigationController popViewControllerAnimated:YES];
}
@end
