//
//  BaseViewPagerController.m
//  HiTV
//
//  created by iSwift on 3/9/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BaseViewPagerController.h"

@interface BaseViewPagerController ()

@property (nonatomic, strong) UIImageView* mineBackgroundImageView;

@end

@implementation BaseViewPagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.menusArray = [[NSMutableArray alloc] init];
    self.contentsArray = [[NSMutableArray alloc] init];
    self.dataSource = self;
    self.delegate = self;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineBackground"]];
    imageView.contentMode = UIViewContentModeTop;
    [self.view insertSubview:imageView atIndex:0];
    imageView.frame = self.view.bounds;
    self.mineBackgroundImageView = imageView;
    
    [self enableToScroll];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view sendSubviewToBack:self.mineBackgroundImageView];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setMenuTitlesArray:(NSArray *)menuTitlesArray{
    _menuTitlesArray = menuTitlesArray;
    
    [self.menusArray removeAllObjects];
    [self.contentsArray removeAllObjects];

    for (int index = 0; index < menuTitlesArray.count; index ++) {
        [self.menusArray addObject:[NSNull null]];
        [self.contentsArray addObject:[NSNull null]];
    }
    [self reloadData];
}

- (UIFont*)fontForTopBar{
    return [UIFont systemFontOfSize:18];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.menuTitlesArray.count;
}

#pragma mark - ViewPagerDataSource
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = nil;
    if ([self.menusArray[index] isKindOfClass:[NSNull class]]) {
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.menuTitlesArray[index];
        label.font = [self fontForTopBar];
        [label sizeToFit];
        label.backgroundColor = [UIColor clearColor];
        self.menusArray[index]  = label;
    }else{
        label = self.menusArray[index];
    }
    
    if (index == self.selectedIndex) {
        UIColor* selectedColor = kColorBlueTheme;
        if (self.menusColorArray.count > index) {
            selectedColor = self.menusColorArray[index];
        }

        label.textColor = selectedColor;
    }else{
        label.textColor = [UIColor blackColor];
    }
    
    return label;
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabWidth:
            return 320.0f/self.menuTitlesArray.count;
        case ViewPagerOptionTabHeight:
            return 42.0;
        case ViewPagerOptionImageIndicator:
            return 1.0f;

        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
            //modify by jianghailiang
        case ViewPagerIndicator:
            //return [HiTVConstants titleColorForSelectedTVText];
            return kColorBlueTheme;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
        case ViewPagerContent:
            return klightGrayColor;
            //modify end
        default:
            return color;
    }
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    if (self.selectedIndex != index) {
        UILabel* label = self.menusArray[self.selectedIndex];
        label.textColor = [UIColor blackColor];
        
        label = self.menusArray[index];
        
        UIColor* selectedColor = kColorBlueTheme;
        if (self.menusColorArray.count > index) {
            selectedColor = self.menusColorArray[index];
        }
        label.textColor = selectedColor;
        self.selectedIndex = index;
    }
}

@end
