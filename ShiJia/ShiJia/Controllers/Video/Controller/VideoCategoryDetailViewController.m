//
//  VideoCategoryDetailViewController.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoCategoryDetailViewController.h"
#import "VideoCategoryDetailCollectionViewController.h"
#import "VideoDataProvider.h"
#import "SearchViewController.h"

@interface VideoCategoryDetailViewController()

@property (strong, nonatomic) VideoCategory* videoCategory;
@property (weak, nonatomic) IBOutlet UIView *tabContentBackgroundView;

@end

@implementation VideoCategoryDetailViewController


- (instancetype)initWithVideoCategory:(VideoCategory*)videoCategory{
    if (self = [super init]) {
        self.videoCategory = videoCategory;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DDLogInfo(@"VideoCategoryDetailViewController : vewDidLoad");

    self.title = self.videoCategory.catgName;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"searchicon" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goSearchVC)];
    self.navigationItem.rightBarButtonItem = searchItem;
    //如果是优惠券内部跳转（openActivity）先通过catId获取二级栏目
    //if ([self.videoCategory.action isEqualToString:@"openActivity"]) {
        [self getCatginfoByFidRequest];
    /*}
    else{
        [self p_reloadTopMenus];
    }*/
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.view sendSubviewToBack:self.tabContentBackgroundView];
}
-(void)goSearchVC
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)p_reloadTopMenus{
    if (self.videoCategory.subCategoriesArray.count == 0) {
        self.menuTitlesArray = @[@""];
    }else{
        NSMutableArray* topMenus = [NSMutableArray arrayWithCapacity:self.videoCategory.subCategoriesArray.count];
        for (VideoCategory* category in self.videoCategory.subCategoriesArray) {
            [topMenus addObject:category.catgName];
        }
        self.menuTitlesArray = topMenus;
    }
    if (self.menusArray.count>=self.videoCategory.index.intValue &&self.videoCategory.index.intValue>0) {
     [self selectTabAtIndex:self.videoCategory.index.intValue-1];
    }
    else{
        for (VideoCategory* category in self.videoCategory.subCategoriesArray) {
            if (category.catgId.intValue == self.videoCategory.catgId.intValue) {
                [self selectTabAtIndex:[self.videoCategory.subCategoriesArray indexOfObject:category]];
                break;
            }
        }
    }

    //[self setNeedsReloadColors];
}

- (UIFont*)fontForTopBar{
    return [UIFont systemFontOfSize:16];
}

#pragma mark - ViewPagerDataSource

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabWidth:
            if (value<60) {
                return 60;
            }
            return value;
        case ViewPagerOptionImageIndicator:
            return 1.0;
        default:
            return [super viewPager:viewPager valueForOption:option withDefault:value];
    }
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    UIViewController* controller = self.contentsArray[index];
    if (![controller isKindOfClass:[UIViewController class]]) {
        
        if (index >= self.videoCategory.subCategoriesArray.count) {
            controller = [[UIViewController alloc] init];
//            controller.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"backgroud"] ];
        }else{
            VideoCategory* category = self.videoCategory.subCategoriesArray[index];
//            if ([category.actionUrl isEqualToString:@"GetMenusList"]) {
//                controller = [[VideoCategoryDetailViewController alloc] initWithVideoCategory:category];
//            }else{
                controller = [[VideoCategoryDetailCollectionViewController alloc] initWithVideoCategory:category];
            //}
        }
        
        self.contentsArray[index] = controller;;
    }
    return controller;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        default:
            return [super viewPager:viewPager
                  colorForComponent:component
                        withDefault:color];
    }
}


- (void)getCatginfoByFidRequest{
    __weak __typeof(self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString* url = [NSString stringWithFormat:@"%@/web/getCatginfoByFid.json?templateId=%@&abilityString=%@&catgId=%@",FUSE_EPG, [HiTVGlobals sharedInstance].getEpg_groupId,T_STBext,/*@"216209"*/self.videoCategory.parentCatgId];

    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        NSMutableArray* resultCategories = [NSMutableArray array];
        self.title = responseObject[@"catgName"];

        NSArray *resultArray = (NSArray *)responseObject[@"subCatgs"];
        if (resultArray.count == 0) {
            /*VideoCategory *entity = [[VideoCategory alloc] initWithDictionary:(NSDictionary *)responseObject];
            if (entity.subCategoriesArray.count==0) {
                NSMutableArray *arr = [NSMutableArray new];
                VideoCategory *videoCategory = [VideoCategory new];
                videoCategory.catgId = entity.catgId;
                videoCategory.catgName = entity.catgName;
                [arr addObject:videoCategory];
                
                entity.subCategoriesArray = arr;
            }
            [resultCategories addObject:entity];*/
        }
        else{
            for (NSDictionary *videoCategory in resultArray) {
                NSArray *channelIdList = [[HiTVGlobals sharedInstance].offline_COLUMN componentsSeparatedByString:NSLocalizedString(@",", nil)];
                NSString *catgId = [NSString stringWithFormat:@"%@",videoCategory[@"catgId"]];
                BOOL IsOffline = [channelIdList containsObject:catgId];
                
                if (!IsOffline) {
                    VideoCategory *entity = [[VideoCategory alloc] initWithDictionary:videoCategory];
                    if (entity.subCategoriesArray.count==0) {
                        NSMutableArray *arr = [NSMutableArray new];
                        VideoCategory *videoCategory = [VideoCategory new];
                        videoCategory.catgId = entity.catgId;
                        videoCategory.catgName = entity.catgName;
                        [arr addObject:videoCategory];
                        
                        entity.subCategoriesArray = arr;
                    }
                    [resultCategories addObject:entity];
                }
            }
        }
        
        strongSelf.videoCategory.subCategoriesArray = resultCategories;
        [strongSelf p_reloadTopMenus];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf p_handleNetworkError];
    }];
}
@end
