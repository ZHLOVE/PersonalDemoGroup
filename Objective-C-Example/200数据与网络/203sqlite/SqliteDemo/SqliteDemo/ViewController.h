//
//  ViewController.h
//  SqliteDemo
//
//  Created by niit on 15/11/4.
//  Copyright © 2015年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)modify:(id)sender;
- (IBAction)find:(id)sender;
- (IBAction)findAll:(id)sender;

@end

