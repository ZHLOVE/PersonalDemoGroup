//
//  SearchViewController.m
//  TestAge
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SearchViewController.h"

#import <UIImageView+WebCache.h>

#import "NetManager.h"
#import "ResultViewController.h"


@interface SearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rightView.layer.shadowOffset = CGSizeMake(5, 5);
    self.rightView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.rightView.layer.shadowOpacity = 0.8;
                                         
    self.bottomView.layer.shadowOffset = CGSizeMake(5, 5);
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOpacity = 0.8;
    // 为textField添加代理
    self.nameTextField.delegate = self;
    
    // 请求图片
    [self requestPhotoList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestPhotoList
{
    [NetManager searchImagesByName:self.nameTextField.text successBlok:^(NSArray *imgList) {
        
        // 把图片显示到scrollView上
        for(int i=0;i<imgList.count;i++)
        {
            NSString *urlStr = imgList[i];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = 100+i;
            imgView.frame = CGRectMake((i+1)*200,0,200,200);
            [self.scrollView addSubview:imgView];
            // 加载图片 (SDWebImage）
            // ...
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        self.scrollView.contentSize = CGSizeMake(imgList.count * 200, 200);
        
    } failBlok:^(NSError *error) {
        
    }];
    
    
}



- (IBAction)goSettings:(id)sender
{

}

- (IBAction)useThisPhoto:(id)sender
{
    // 得到在scrollView上当前选中的图片
    //
    // 偏移 self.scrollView.contentOffset
    int curSel = self.scrollView.contentOffset.x / 200;
    NSLog(@"当前是第几张图片:%i",curSel);
    UIImageView *imgView = [self.scrollView viewWithTag:100+curSel];
    // UIImageView image -> NSData
    NSData *imgData = UIImageJPEGRepresentation(imgView.image, 0.5);
    ResultViewController *resultVC = [[ResultViewController  alloc] init];
    resultVC.imageData = imgData;
    [self presentViewController:resultVC animated:YES completion:nil];
}

- (IBAction)useOwnPhoto:(id)sender
{
    
}

#pragma mark - TextField的事件处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"输入了:%@",textField.text);
    
    [self requestPhotoList];
    [self backgroundTap];
    return YES;
}

- (void)backgroundTap
{
    [self.view endEditing:YES];
}

@end
