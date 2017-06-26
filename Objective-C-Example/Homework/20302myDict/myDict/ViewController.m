//
//  ViewController.m
//  myDict
//
//  Created by student on 16/4/13.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "ViewController.h"

#import "SQLite.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;



@end

@implementation ViewController


- (IBAction)quaryBtnPressed:(id)sender {
    NSString *str = [[NSString alloc]init];
    SQLite *sqlLite = [SQLite shareSQLite];
    [sqlLite openDB];
    
    NSArray *array = [[sqlLite quaryInfoWithStr:self.textField.text]copy];
    for (NSDictionary *dict in array) {
        NSString *word = dict[@"word"];
        NSString *explain = dict[@"explain"];
        NSString *phonetic = dict[@"phonetic"];
        str = [NSString stringWithFormat:@"%@\n %@\n %@\n",word,explain,phonetic];
//        [mStr appendString:dict[@"phonetic"]];
//        NSLog(@"%@,%@,%@",dict[@"word"],dict[@"explain"],dict[@"phonetic"]);
        
    }
    self.textView.text = [str copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
