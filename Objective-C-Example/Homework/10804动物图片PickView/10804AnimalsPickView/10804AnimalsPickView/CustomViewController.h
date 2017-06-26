//
//  CustomViewController.h
//  10804AnimalsPickView
//
//  Created by 马千里 on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIPickerView *animalsPickerView;
@property (nonatomic,strong) IBOutlet UILabel *animalLabel;
@property (nonatomic,strong) IBOutlet UILabel *resultLabel;

- (NSString *)animalsName:(NSInteger)row;
@end
