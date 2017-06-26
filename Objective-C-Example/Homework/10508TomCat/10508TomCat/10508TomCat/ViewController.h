//
//  ViewController.h
//  10508TomCat
//
//  Created by 马千里 on 16/2/20.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//@property(nonatomic,strong) NSMutableArray *imagesArray;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTomCat;

- (IBAction)headBtnPressed:(UIButton *)sender;
- (IBAction)happy_simpleBtnPressed:(UIButton *)sender;
- (IBAction)happyBtnPressed:(UIButton *)sender;
- (IBAction)left_footBtnPressed:(UIButton *)sender;
- (IBAction)right_footBtnPressed:(UIButton *)sender;
- (IBAction)eatBirdBtnPressed:(UIButton *)sender;
- (IBAction)drinkBtnPressed:(UIButton *)sender;


@end

