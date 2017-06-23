//
//  ViewController.m
//  画图
//
//  Created by niit on 16/4/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "DrawView.h"
#import "UIImage+ColorAtPixel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DrawView *drawView;


@property (weak, nonatomic) IBOutlet UIButton *selColorBtn;

@property (nonatomic,strong) UIView *selBgView;
@property (nonatomic,weak) UIView *curSelColorView;
@property (nonatomic,weak) UIImageView *colorImageView;
@property (nonatomic,strong) UIView *selColorView;

@end

@implementation ViewController

- (UIView *)selBgView
{
    if(_selBgView == nil)
    {
        _selBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 568)];
        _selBgView.backgroundColor = [UIColor blackColor];
        _selBgView.alpha = 0.4;
        [self.view addSubview:_selBgView];
    }
    return _selBgView;
}

- (UIView *)selColorView
{
    if(_selColorView == nil)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 300)];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [view addSubview:bgView];
        _selColorView = view;
        
        UIView *curSelColorView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
        curSelColorView.backgroundColor = [UIColor whiteColor];
        [view addSubview:curSelColorView];
        self.curSelColorView = curSelColorView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorwheel"]];
        imageView.frame = CGRectMake(10, 0, 300, 300);
        [view addSubview:imageView];
        self.colorImageView = imageView;
        [self.view addSubview:view];
    }
    return _selColorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)undoBtnPressed:(id)sender {
    [self.drawView undo];
}

- (IBAction)clearBtnPressed:(id)sender
{
    [self.drawView clear];
}

- (IBAction)whiteBtnPressed:(id)sender {
    self.drawView.curColor = [UIColor whiteColor];
}
- (IBAction)saveBtnPressed:(id)sender {
}


- (IBAction)sliderChanged:(UISlider *)sender
{
    self.drawView.curLineWidth = sender.value;
}

- (IBAction)redBtnPressed:(id)sender
{
    self.drawView.curColor = [UIColor redColor];
}
- (IBAction)yellowBtnPressed:(id)sender {
    
    self.drawView.curColor = [UIColor yellowColor];
}

- (IBAction)selColorBtnPressed:(id)sender
{

    [self showSelColorView];
}

- (void)showSelColorView
{
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.selBgView.frame = CGRectMake(0, 0, 320, 568);
                            self.selColorView.frame = CGRectMake(0, 568-300, 320,300);
                        } completion:^(BOOL finished) {
                            
                        }];
}

- (void)hideSelColorView
{
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.selBgView.frame = CGRectMake(0, 568, 320, 568);
                            self.selColorView.frame = CGRectMake(0, 568, 320,300);
                        } completion:^(BOOL finished) {
                            
                        }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 触摸点位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.colorImageView];
    
    UIImage *img = [UIImage imageNamed:@"colorwheel"];
    UIColor *selColor = [img colorAtPixel:point];
    
    self.curSelColorView.backgroundColor = selColor;
    self.drawView.curColor = selColor;
    self.selColorBtn.backgroundColor = selColor;
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 触摸点位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.colorImageView];
    
    UIImage *img = [UIImage imageNamed:@"colorwheel"];
    UIColor *selColor = [img colorAtPixel:point];
    
    self.curSelColorView.backgroundColor = selColor;
    self.drawView.curColor = selColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideSelColorView];
}
@end
