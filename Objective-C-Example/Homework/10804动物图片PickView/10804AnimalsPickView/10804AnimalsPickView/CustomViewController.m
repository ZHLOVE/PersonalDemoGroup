//
//  CustomViewController.m
//  10804AnimalsPickView
//
//  Created by 马千里 on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>



@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *sounds;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animalsPickerView.dataSource = self;
    self.animalsPickerView.delegate = self;
    self.images = @[[UIImage imageNamed:@"gou"],
                    [UIImage imageNamed:@"mao"],
                    [UIImage imageNamed:@"niu"],
                    [UIImage imageNamed:@"shu"],
                    [UIImage imageNamed:@"yang"]];
    self.sounds = @[@"汪汪",@"喵喵",@"哞~",@"吱吱",@"咩咩"];
    
}

- (NSString *)animalsName:(NSInteger) row
{
    switch (row) {
        case 0:return @"狗";break;
        case 1:return @"猫";break;
        case 2:return @"牛";break;
        case 3:return @"鼠";break;
        case 4:return @"羊";break;
        default:return nil;break;
    }

}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.images.count;
    }else{
        return self.sounds.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.images[row]];
    if (component == 0) {
        return imageView;
    }else{
        return nil;
    }
    
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 1) {
//        return self.sounds[row];
//    }else{
//        return nil;
//    }
//}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.animalLabel.text = [NSString stringWithFormat:@"你选择的动物是%@",[self animalsName:row]];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return 30;
//}





@end
