//
//  OtherViewController.m
//  LGJ
//
//  Created by student on 16/5/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "OtherViewController.h"
#import "DWTableMenu.h"
#import "XCFTableViewCell.h"
#import "def.h"
#import "UIImageView+WebCache.h"
#import "FoodData.h"

#import <TFHpple.h>
#import <MJRefresh.h>
#import <AFNetworking.h>


// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@interface OtherViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) DWTableMenu *menu;
@property (nonatomic,strong) NSMutableArray *foodDataArray; //存放下厨房上的数据模型
@property (nonatomic,strong) UITableView *tableView;//表格
@property (weak, nonatomic) UIImageView *image;
@property (assign, nonatomic) CGPoint touchPoint;
@property (weak, nonatomic) UIView *viewClick;
@property (nonatomic,strong) NSArray *foodArray;

@property(nonatomic,strong) NSString *htmlStr;
@property(nonatomic,strong) NSNumber *pageNumber;
@property (nonatomic,strong) NSDictionary *allDict; //网络请求字典
@property (nonatomic,strong) NSString *keyword; //搜索关键字
@property(nonatomic,strong) NSMutableArray *xcfFoodArray;
@property(nonatomic,strong) NSMutableArray *foodImgArray;//图片
@property(nonatomic,strong) NSMutableArray *titleArray;//标题

@end

@implementation OtherViewController


//懒加载
- (NSNumber *)pageNumber{
    if (_pageNumber == nil) {
        _pageNumber = [NSNumber numberWithInt:1];
    }
    return _pageNumber;
}


- (NSMutableArray *)foodImgArray{
    if (_foodImgArray == nil) {
        _foodImgArray = [NSMutableArray array];
    }
    return _foodImgArray;
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSDictionary *)allDict{
    if (_allDict == nil) {
        _allDict = [NSMutableDictionary dictionary];
    }
    return _allDict;
}

- (NSArray *)foodArray{
    if (_foodArray == nil) {
        _foodArray = [NSArray array];
    }
    return _foodArray;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册单元格模板
    [_tableView registerClass:[XCFTableViewCell class] forCellReuseIdentifier:@"XCFcell"];

    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    return _tableView;
}

- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    [self getData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.foodImgArray removeAllObjects];
    [self.titleArray removeAllObjects];
    self.menu.leftMenus = [DataBase quaryAllData];
    NSArray *arr = [DataBase quaryAllData];
    NSMutableArray *mArr = [NSMutableArray array];
    for (DataModel *m in arr) {
        [mArr addObject:m.name];
    }
    self.foodArray = [mArr copy];
    
    [self getData];
}



- (void)setUI{
    
    self.pageNumber = 0;
    NSArray *arr = [DataBase quaryAllData];
    NSMutableArray *mArr = [NSMutableArray array];
    for (DataModel *m in arr) {
        [mArr addObject:m.name];
    }
    self.foodArray = [mArr copy];
    self.keyword = self.foodArray[0];
    self.tableView.rowHeight = 140;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.bottom).offset(-49);
        make.width.equalTo(self.view.width);
        make.left.equalTo(0);
    }];
    
    self.title = @"下厨房";
    self.view.backgroundColor = [UIColor whiteColor];
    //创建左侧按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuView)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //添加左菜单视图
    [self addMenu];
    //添加手势
    [self addSwipeGestureRecognizer];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCell:) name:@"push" object:nil];
    
  
}

#pragma mark ---处理点击事件的通知方法
- (void) clickCell:(NSNotification *)cation {
    [self.foodImgArray removeAllObjects];
    [self.titleArray removeAllObjects];
    NSIndexPath *index = [cation object];
    NSString *str = self.foodArray[index.row];
    DLog(@"点击的食物:%@",str);
    self.keyword = str;
    [self returnLeftMenu]; //隐藏掉侧边栏
    [self getData];
}


#pragma mark ---移除通知
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ---添加左菜单视图
- (void) addMenu {
    DWTableMenu *menu = [[DWTableMenu alloc] initWithFrame:MenusFrameAfter];
    self.menu = menu;
    self.menu.scrollEnabled = YES;
    self.menu.tableFooterView = [UIView new];
    [self.view addSubview:self.menu];
}

#pragma mark ---添加手势
- (void) addSwipeGestureRecognizer {
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pelletLeftMenu)];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnLeftMenu)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:swipeLeft];
}

#pragma mark --- 添加点击空白手势方法
- (void) tapGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    
    UIView *view = [[UIView alloc] initWithFrame:viewClickFrame];
    
    view.backgroundColor = [UIColor clearColor];
    
    [view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:view];
    
    self.viewClick = view;
    
}


#pragma mark --- 左侧按钮点击方法
- (void) leftMenuView {
    
    if (MenuWidth == 0 || self.menu == nil) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self tapGesture];
            
            self.menu.frame = MenusFrame;
            
            self.image.frame = ImageFrame;
            
        }];
        
    }else {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.viewClick removeFromSuperview];
            
            self.menu.frame = MenusFrameAfter;
            
            self.image.frame = Frame;
            
        }];
        
    }
}




#pragma mark --- 右滑手势方法
- (void) pelletLeftMenu {
    
    if (MenuWidth == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self tapGesture];
            
            self.menu.frame = MenusFrame;
            
            self.image.frame = ImageFrame;
            
        }];
    }else {
        
        return;
        
    }
}

#pragma mark --- 左滑手势方法
- (void) returnLeftMenu {
    
    if (MenuWidth != 0 ) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.viewClick removeFromSuperview];
            
            self.menu.frame = MenusFrameAfter;
            
            self.image.frame = Frame;
            
        }];
    }else {
        return;
    }

}

#pragma mark ---获取点击坐标
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
    
    self.touchPoint = touchPoint;
    
}

#pragma mark ---点击空白执行
- (void) clickView {
    
    if (self.touchPoint.x < ScreenWidth / 4 * 3) {
        
        [self.viewClick removeFromSuperview];
        
        [self returnLeftMenu];
        
        self.image.frame = Frame;
        
    }else {
        
        return;
        
    }
}

#pragma mark 离开时收起侧菜单
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.menu.frame = MenusFrameAfter;
}



#pragma mark 网络请求
- (void)getData
{
    
    self.htmlStr = [[NSString stringWithFormat:@"http://www.xiachufang.com/search/?keyword=%@&cat=1001&page=%@",self.keyword,self.pageNumber]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    DLog(@"%@",self.htmlStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //由于解析html，所以在AFNetWorking中修改了AFURLResponseSerialization.m的第229行
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//并且增加了这行
    [manager GET:self.htmlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //使用TFHpple解析網頁
             DLog(@"这里打印请求成功要做的事");
             TFHpple *htmlHpple = [TFHpple hppleWithHTMLData:responseObject];
             NSString *str = @"//div[@class='recipe-140-horizontal pure-g']/div[@class='cover pure-u']/a/img";
             NSArray *arr = [htmlHpple searchWithXPathQuery:str];
             
             for (TFHppleElement *tmp in arr) {
                 NSDictionary *dict = tmp.attributes;
                 [self.foodImgArray addObject:dict[@"data-src"]];
                 [self.titleArray addObject:dict[@"alt"]];
             }
             self.allDict = @{@"pic":self.foodImgArray,@"title":self.titleArray};
             [self.tableView reloadData];
             //截取页码地址
             NSString *html = @"//div/div[@class='pager']/a";
             NSArray *moreArr = [htmlHpple searchWithXPathQuery:html];
             for (TFHppleElement *hppleElement in moreArr) {
                 //如果有第二页
                 if ([hppleElement.text intValue] == 2) {
                     self.htmlStr = [@"http://www.xiachufang.com" stringByAppendingString:hppleElement.attributes[@"href"]];
                 }else{
                     DLog(@"没有下一页了");
                 }
             }

         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             [self endRefresh];
             DLog(@"请求失败%@",error);  //这里打印错误信息
         }];
}

- (void)loadMoreData{
//    DLog(@"%@",self.htmlStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //由于解析html，所以在AFNetWorking中修改了AFURLResponseSerialization.m的第229行
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//并且增加了这行
    [manager GET:self.htmlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //使用TFHpple解析網頁
             DLog(@"这里打印请求成功要做的事");
             TFHpple *htmlHpple = [TFHpple hppleWithHTMLData:responseObject];
             NSString *imgStr = @"//div[@class='recipe-140-horizontal pure-g']/div[@class='cover pure-u']/a/img";
//             NSString *infoStr = @"//div[@class='recipe-140-horizontal pure-g']/div[@class='info pure-u']/p";
             NSArray *arr = [htmlHpple searchWithXPathQuery:imgStr];
             for (TFHppleElement *tmp in arr) {
                 NSDictionary *dict = tmp.attributes;
                 [self.foodImgArray addObject:dict[@"data-src"]];
                 [self.titleArray addObject:dict[@"alt"]];
             }
             self.allDict = @{@"pic":self.foodImgArray,@"title":self.titleArray};
             [self.tableView reloadData];
             //下一页的连接复制给htmlStr
             NSMutableString *mPageStr = [[self.htmlStr substringWithRange:NSMakeRange(0, [self.htmlStr length] - 1)] mutableCopy];
             NSString *pageStr = [self.htmlStr substringFromIndex:self.htmlStr.length-1];
             int pageInt = [pageStr intValue];
             pageInt++;
             [mPageStr appendString:[NSString stringWithFormat:@"%d",pageInt]];
             DLog(@"%@",mPageStr);
             self.htmlStr = [mPageStr copy];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             [self endRefresh];
             DLog(@"请求失败%@",error);  //这里打印错误信息
         }];
}

#pragma mark 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.foodImgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XCFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XCFcell" forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[XCFTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"XCFcell"];
    }
    NSArray *picArr = self.allDict[@"pic"];
    NSArray *titleArr = self.allDict[@"title"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:picArr[indexPath.row]]];
//    DLog(@"收到的图片%@",[UIImage imageWithData:imgData]);
//    DLog(@"单元格的图片%@",cell.imgView.image);
    cell.titleLabel.text = titleArr[indexPath.row];
    return cell;
}


#pragma mark MJRefresh
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_header endRefreshing];
}
@end
