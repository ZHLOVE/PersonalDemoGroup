//
//  NoteViewController.m
//  NotePad
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()


@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.date.text = self.noteData.CDate;
    self.textView.text = self.noteData.Content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
