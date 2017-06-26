//
//  DetailController.m
//  60004TextBook
//
//  Created by 马千里 on 16/3/13.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DetailController.h"

@interface DetailController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property(nonatomic,strong)NSMutableArray *noteArray;

@end

@implementation DetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = self.noteArray[self.row];
}

- (NSArray *)noteArray{
    if (_noteArray == nil) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *array = [NSMutableArray array];
        array = [[userDefault objectForKey:@"NoteBook"] copy];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            Data *noteDate = [Data dataWithDict:dict];
            [mArray addObject:noteDate];
        }
        _noteArray = [mArray mutableCopy];
        return _noteArray;
    }
    return _noteArray;
}

- (void)setData:(Data *)data{
    _titleTextField.text = data.title;
    _timeLabel.text = data.time;
    _detailTextView.text = data.detail;
}

- (void)viewWillDisappear:(BOOL)animated{
    //返回时候同步一下
    [Data updateNote:self.row andTitle:self.titleTextField.text andTime:self.timeLabel.text andDetail:self.detailTextView.text];
}

@end
