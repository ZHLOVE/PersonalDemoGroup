//
//  ViewController.h
//  10507
//
//  Created by 马千里 on 16/2/20.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *imageArr;

@property (weak, nonatomic) IBOutlet UILabel *pageNum;
@property (weak, nonatomic) IBOutlet UILabel *pageNumMax;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

- (IBAction)leftBtnPressed:(UIButton *)sender;

- (IBAction)rightBtnPressed:(UIButton *)sender;

@end

