//
//  TVDetailDateViewController.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "TVDetailDateViewController.h"
#import "TVStationDetail.h"
#import "TVProgrameListViewController.h"
#import "HiTVDateView.h"
#define TVTabHeight       55

@interface TVDetailDateViewController ()<ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic, strong) NSMutableArray* menusArray;
@property (nonatomic, strong) NSMutableArray* contentsArray;

@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic,strong) NSDate *day;

@end

@implementation TVDetailDateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.hidesBottomBarWhenPushed = YES;
    self.menusArray = [[NSMutableArray alloc] init];
    self.contentsArray = [[NSMutableArray alloc] init];

    self.delegate = self;
    self.dataSource = self;
}

- (void)setTvDateListArray:(NSArray *)tvDateListArray{

    for (NSUInteger index = _tvDateListArray.count; index < tvDateListArray.count; index ++) {
        [self.menusArray addObject:[NSNull null]];
        [self.contentsArray addObject:[NSNull null]];
    }
    
    //_tvDateListArray = tvDateListArray;
    _tvDateListArray = [[tvDateListArray reverseObjectEnumerator] allObjects];

    /*self.selectedIndex = self.tvDateListArray.count - 1;

    TVStationDetail* onlineTV = [self.tvDateListArray lastObject];
    TVProgram* onlineProgram = onlineTV.onlineProgram;
    if (!onlineProgram && !onlineProgram && self.tvDateListArray.count > 1) {
        onlineTV = self.tvDateListArray[self.tvDateListArray.count - 2];
        onlineProgram = onlineTV.onlineProgram;
        self.selectedIndex = self.tvDateListArray.count - 2;
    }
    if (!onlineProgram) {
        self.selectedIndex = 0;
    }*/
    self.selectedIndex = 0;
    if (self.day) {
        for (TVStationDetail* tvStationDetail in self.tvDateListArray) {
            double serverTime = [tvStationDetail.playDate doubleValue];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
            if ([self.day day]== [date day]) {
                self.selectedIndex = [self.tvDateListArray indexOfObject:tvStationDetail];
                break;
            }
        }
    }
    else{
        for (TVStationDetail* tvStationDetail in self.tvDateListArray) {
            double serverTime = [tvStationDetail.playDate doubleValue];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
            if ([date day] == [[NSDate date] day]) {
                self.selectedIndex = [self.tvDateListArray indexOfObject:tvStationDetail];
                break;
            }
            
        }
    }
    [self reloadData];
    [self setNeedsReloadColors];
}

- (void)selectProgram:(TVProgram*)program ForList:(NSArray*)programList{
    for (NSUInteger index = 0; index < self.tvDateListArray.count; index ++) {
        TVStationDetail* date = self.tvDateListArray[index];
        
        if(date.programs == programList){
            [self selectTabAtIndex:index];
            
            TVProgrameListViewController* controller = self.contentsArray[index];
            [controller selectProgram:program];
            controller.uuid = self.uuid;
            controller.date = date;

            break;
        }

    }
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.tvDateListArray.count;
}

#pragma mark - ViewPagerDataSource
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    HiTVDateView* dateView = nil;
    //if ([self.menusArray[index] isKindOfClass:[NSNull class]]) {
        TVStationDetail* date = self.tvDateListArray[index];

        dateView = (HiTVDateView*)[[[NSBundle mainBundle] loadNibNamed:@"HiTVDateView" owner:nil options:nil] firstObject];
        dateView.backgroundColor = [UIColor whiteColor];
        dateView.weekdayLabel.text = [date displayedWeekDay];
        dateView.dateLabel.text = [date displayedDate];

        CGRect frame = dateView.frame;
        frame.size.width = W/7;
        frame.size.height = TVTabHeight-10;

        dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH/7, TVTabHeight-10);

        self.menusArray[index]  = dateView;
    /*}else{
        dateView = self.menusArray[index];
    }*/
    [dateView setSelected:index == self.selectedIndex];

    return dateView;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    TVProgrameListViewController* controller = self.contentsArray[index];
    if (![controller isKindOfClass:[UIViewController class]]) {
        controller = [[TVProgrameListViewController alloc] init];
        controller.view.backgroundColor = klightGrayColor;
        self.contentsArray[index] = controller;;
    }
    TVStationDetail* date = self.tvDateListArray[index];

    controller.programs = date.programs;
    controller.uuid = self.uuid;
    controller.date = date;
    return controller;
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    if (self.selectedIndex != index) {
        HiTVDateView* dateView = self.menusArray[self.selectedIndex];
        [dateView setSelected:NO];

        dateView = self.menusArray[index];
        [dateView setSelected:YES];
        self.selectedIndex = index;
        
        TVStationDetail* tvStationDetail = self.tvDateListArray[index];

        double serverTime = [tvStationDetail.playDate doubleValue];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
        self.day = date;
    }
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    //modify by jzb
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return self.selectedIndex;
        case ViewPagerOptionCenterCurrentTab:
            return 10.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabWidth:
//            return 320.0f/self.tvDateListArray.count;
            return self.view.bounds.size.width/7;
        case ViewPagerOptionTabHeight:
//            return 36.0;
            return TVTabHeight;
        case ViewPagerOptionTriangleHeight:
            return 0.0;
            
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
            //modify by jianghailiang 20150810
            /*return [UIColor colorWithRed:251.0f/255.0f
             green:251.0f/255.0f
             blue:251.0f/255.0f
             alpha:1];
            return [UIColor colorWithRed:30.0f/255.0f
                                   green:30.0f/255.0f
                                    blue:30.0f/255.0f
                                   alpha:1];
             */
            return [UIColor whiteColor];
        case ViewPagerContent:
            //modify by jianghailiang 20150203
            /*return [UIColor colorWithRed:234.0f/255.0f
                                   green:232.0f/255.0f
                                    blue:233.0f/255.0f
                                   alpha:1];*/
//            return [UIColor colorWithRed:34.0f/255.0 green:34.0f/255.0 blue:34.0f/255.0 alpha:1.0];
            return [UIColor clearColor];
            //modify end
        default:
            return color;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.bounces = NO;
    scrollView.pagingEnabled = NO;

}
@end
