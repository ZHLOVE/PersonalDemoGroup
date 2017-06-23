//
//  ViewController.m
//  UIToolBarDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupToolBar];
}

- (void)setupToolBar
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    // 1. 创建ToolBar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, winSize.height-44.0f, winSize.width, 44.0f)];
    [self.view addSubview:toolBar];
    
    // 2. 创建按钮项目
    // 2.1 文字
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"文字" style:UIBarButtonItemStylePlain target:nil action:nil];
    
//    - (instancetype)initWithImage:(nullable UIImage *)image style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action;
//    - (instancetype)initWithImage:(nullable UIImage *)image landscapeImagePhone:(nullable UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action NS_AVAILABLE_IOS(5_0); // landscapeImagePhone will be used for the bar button image when the bar has Compact or Condensed bar metrics.
//    - (instancetype)initWithTitle:(nullable NSString *)title style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action;
//    - (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action;
//    - (instancetype)initWithCustomView:(UIView *)customView;
    
    // 2.2 通过图片
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1204"] style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"1204"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 2.3 系统
//    UIBarButtonSystemItemDone,
//    UIBarButtonSystemItemCancel,
//    UIBarButtonSystemItemEdit,
//    UIBarButtonSystemItemSave,
//    UIBarButtonSystemItemAdd,
//    UIBarButtonSystemItemFlexibleSpace,
//    UIBarButtonSystemItemFixedSpace,
//    UIBarButtonSystemItemCompose,
//    UIBarButtonSystemItemReply,
//    UIBarButtonSystemItemAction,
//    UIBarButtonSystemItemOrganize,
//    UIBarButtonSystemItemBookmarks,
//    UIBarButtonSystemItemSearch,
//    UIBarButtonSystemItemRefresh,
//    UIBarButtonSystemItemStop,
//    UIBarButtonSystemItemCamera,
//    UIBarButtonSystemItemTrash,
//    UIBarButtonSystemItemPlay,
//    UIBarButtonSystemItemPause,
//    UIBarButtonSystemItemRewind,
//    UIBarButtonSystemItemFastForward,
//    UIBarButtonSystemItemUndo NS_ENUM_AVAILABLE_IOS(3_0),
//    UIBarButtonSystemItemRedo NS_ENUM_AVAILABLE_IOS(3_0),
//    UIBarButtonSystemItemPageCurl NS_ENUM_AVAILABLE_IOS(4_0),
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
    
    // 2.4 自定义
//    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"鸡腿",@"大牌"]];
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithCustomView:seg];
    
    // 2.5 弹簧
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem1.width = 50;
    
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[item1,spaceItem1,item2,item3,spaceItem2,item4,item5];
    
    // 颜色
    toolBar.tintColor = [UIColor redColor];
    
    toolBar.backgroundColor = [UIColor blackColor];
    toolBar.barStyle = UIBarStyleBlack;
    
    [toolBar setBackgroundImage:[UIImage imageNamed:@"22"] forToolbarPosition:0 barMetrics:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
