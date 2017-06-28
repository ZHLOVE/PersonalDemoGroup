//
//  ViewController.m
//  LSPageControl
//
//  Created by  sen on 15/8/28.
//  Copyright (c) 2015年  sen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIScrollView* rootview;
    CGFloat subview_h;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    rootview.frame = self.view.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//        if (IsiOS7) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//            //        self.extendedLayoutIncludesOpaqueBars = NO;
//            //        self.modalPresentationCapturesStatusBarAppearance = NO;
//            //        self.navigationController.navigationBar.translucent = YES;//导航栏透明
//            //   self.tabBarController.tabBar.translucent = NO;
//            self.navigationController.navigationBar.translucent = NO;
//            
//        }
//    #endif
    
    rootview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:rootview];
    
//    [self loadPageView];
    [self loadPageView1];
//    [self loadPageView2];
//    [self loadPageView3];

    subview_h += 30;
    [self reloadRootContentSize];
}

- (void)loadPageView{
    
    UILabel* marklb = [[UILabel alloc] initWithFrame:CGRectMake(10, subview_h, self.view.bounds.size.width-20, 30)];
    marklb.text = @"样式默认";
    marklb.textColor = [UIColor grayColor];
    marklb.font = [UIFont boldSystemFontOfSize:14];
    [rootview addSubview:marklb];
    
    subview_h += marklb.bounds.size.height;
    
    //
    LSPageScrollView* pagescrollview = [[LSPageScrollView alloc] initWithFrame:CGRectMake(0, subview_h, self.view.bounds.size.width, 160) numberOfItem:3 itemSize:CGSizeMake(self.view.bounds.size.width, 160) complete:^(NSArray *items) {
        //code...
        
    }];

    [rootview addSubview:pagescrollview];
    
    subview_h += pagescrollview.bounds.size.height;
    
}

- (void)loadPageView1{
    
    UILabel* marklb = [[UILabel alloc] initWithFrame:CGRectMake(10, subview_h, self.view.bounds.size.width-20, 30)];
    marklb.text = @"样式1";
    marklb.textColor = [UIColor grayColor];
    marklb.font = [UIFont boldSystemFontOfSize:14];
    [rootview addSubview:marklb];
    subview_h = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //
    LSPageScrollView* pagescrollview = [[LSPageScrollView alloc] initWithFrame:CGRectMake(0, subview_h, self.view.bounds.size.width, height) numberOfItem:4 itemSize:CGSizeMake(self.view.bounds.size.width, height) complete:^(NSArray *items) {
        for (int i=0; i<items.count; i++) {
            UIImageView *imgView = (UIImageView *)items[i];
            NSString *str = [NSString stringWithFormat:@"new_feature_%d",i+1];
            [imgView setImage:[UIImage imageNamed:str]];
            if (i == items.count) {
                
            }
        }
    }];
    pagescrollview.defaultPageIndicatorImage = [UIImage imageNamed:@"tb1.png"];
    pagescrollview.currentPageIndicatorImage = [UIImage imageNamed:@"tb2.png"];

    [rootview addSubview:pagescrollview];
    
    subview_h += pagescrollview.bounds.size.height;
    
}

- (void)loadPageView2{
 
    UILabel* marklb = [[UILabel alloc] initWithFrame:CGRectMake(10, subview_h, self.view.bounds.size.width-20, 30)];
    marklb.text = @"样式2";
    marklb.textColor = [UIColor grayColor];
    marklb.font = [UIFont boldSystemFontOfSize:14];
    [rootview addSubview:marklb];
    
    subview_h += marklb.bounds.size.height;
    
    //
    LSPageScrollView* pagescrollview = [[LSPageScrollView alloc] initWithFrame:CGRectMake(0, subview_h, self.view.bounds.size.width, 80) numberOfItem:5 itemSize:CGSizeMake(self.view.bounds.size.width*2/3, 80) complete:^(NSArray *items) {
        //code...
    }];
    pagescrollview.defaultPageIndicatorImage = [UIImage imageNamed:@"tb4.png"];
    pagescrollview.currentPageIndicatorImage = [UIImage imageNamed:@"tb3.png"];
    pagescrollview.pagingEnabled = NO;
    [rootview addSubview:pagescrollview];
    
    subview_h += pagescrollview.bounds.size.height;
    
}

- (void)loadPageView3{
    
    UILabel* marklb = [[UILabel alloc] initWithFrame:CGRectMake(10, subview_h, self.view.bounds.size.width-20, 30)];
    marklb.text = @"样式3";
    marklb.textColor = [UIColor grayColor];
    marklb.font = [UIFont boldSystemFontOfSize:14];
    [rootview addSubview:marklb];
    
    subview_h += marklb.bounds.size.height;
    
    //
    LSPageScrollView* pagescrollview = [[LSPageScrollView alloc] initWithFrame:CGRectMake(0, subview_h, self.view.bounds.size.width, self.view.bounds.size.width/4) numberOfItem:7 itemSize:CGSizeMake(self.view.bounds.size.width/4, self.view.bounds.size.width/4) complete:^(NSArray *items) {
        //code...
        
    }];
    pagescrollview.defaultPageIndicatorImage = [UIImage imageNamed:@"tb1.png"];
    pagescrollview.currentPageIndicatorImage = [UIImage imageNamed:@"tb2.png"];
    pagescrollview.pagingEnabled = NO;
    pagescrollview.pages = 2;
    [rootview addSubview:pagescrollview];
    
    subview_h += pagescrollview.bounds.size.height;
    
}

- (void)reloadRootContentSize{
    
    if (subview_h < SCREEN_HEIGHT-64) {
        //
        rootview.contentSize = CGSizeMake(rootview.bounds.size.width, SCREEN_HEIGHT-63);
    }else{
        rootview.contentSize = CGSizeMake(rootview.bounds.size.width, subview_h);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
