//
//  ViewController.m
//  2048
//
//  Created by niit on 16/3/21.
//  Copyright © 2016年 NIIT. All rights reserved.
//

// AdMob     按照点击
// iAd
// 国内的讯飞
// 百度ssp

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

// 数据结构与算法 (程序员的基本修养)

// 解决问题的基本思路:
// 拆分页面
// 大问题 -> 小问题
// 一大块功能 -> 一步步功能
// 拆分成模块 拆分成步骤
// 1 分析有哪些页面，分出模块
// 2 单个模块单个页面 分出子模块、子流程

#import "CellView.h"

#import "BaiduMobAdView.h"

#define kAdViewPortraitRect CGRectMake(0, [UIScreen mainScreen].bounds.size.height-48, kBaiduAdViewSizeDefaultWidth, kBaiduAdViewSizeDefaultHeight)

@interface ViewController ()<BaiduMobAdViewDelegate>
{
    SystemSoundID mergeSoundId;
    SystemSoundID moveSoundId;
    
    BaiduMobAdView* sharedAdView;
}

@property (nonatomic,strong) UIView *boxView;

// 定义一个数组,保存所有格子里的数字
@property (nonatomic,strong) NSMutableArray *boxArr;

// 记录要产生新格子的Cellid数组
@property (nonatomic,strong) NSMutableArray *mergeCellIdArr;

// 保存要移除的视图
@property (nonatomic,strong) NSMutableArray *needRemoveViewArr;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// 用于计算不同屏幕大小时的按比例的尺寸
#define W(x) ((x)* kScreenWidth / 320.0)
#define H(y) ((y)* kScreenHeight / 568.0)


@implementation ViewController

- (NSMutableArray *)boxArr
{
    if(_boxArr == nil)
    {
        // 一开始创建的时候,格子里都是0
        _boxArr = [NSMutableArray array];
        for (int i=0; i<N*N; i++)
        {
            [_boxArr addObject:@0];
        }
    }
    return _boxArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = kRGBBakcgroundColor;
    
    self.needRemoveViewArr = [NSMutableArray array];
    self.mergeCellIdArr = [NSMutableArray array];
//    制作流程:
//    1. 绘制底板
//    * 画大底板
    [self drawBackBox];
//    * 画每个小格子 4*4
    [self drawBackCell];
    
//    2. 产生新格子
//    点击随机产生2个新的格子(后面移动做好后,改为每次移动之后产生新格子)
//    (需要考虑使用必要的容器保存相关数据)
//    
//    3. 一个方向上的手势移动
//    * 移动
//    * He并
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
//    
//    4. 所有方向
//    
//    5. 加入音效
    [self addSoundEffect];
    
//    
//    6. 输赢判断
    
    // 7. 添加广告
    [self addADView];
}

- (void)addADView
{
    //使用嵌入广告的方法实例。
    sharedAdView = [[BaiduMobAdView alloc] init];
    //把在mssp.baidu.com上创建后获得的广告位id写到这里
    sharedAdView.AdUnitTag = @"2005804";
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    sharedAdView.frame = kAdViewPortraitRect;
    sharedAdView.delegate = self;
    [self.view addSubview:sharedAdView];
    [sharedAdView start];
}

// 应用程序id 上线前改为申请到的APPID
- (NSString *)publisherId
{
    return  @"ccb60059"; //@"your_own_app_id";
}

-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    NSLog(@"will display ad");
}


#pragma mark - 1. 绘制底板
// 1. 绘制底板
- (void)drawBackBox
{
    // 底板宽度 = 格子宽度 * 格子数量 + 格子间距 * 格子数量
    CGFloat boxWidth = W(kCellWidth) * N + W(kCellPadding) * N * 2 + W(kBoxPadding) * 2;
    
    self.boxView = [[UIView alloc] init];
    // 大小
    self.boxView.bounds = CGRectMake(0, 0, boxWidth, boxWidth);
    // 中心点
    self.boxView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    // 背景色
    self.boxView.backgroundColor =  kRGBBoxColor;
    // 圆角
    self.boxView.layer.cornerRadius = 5;
    [self.view addSubview:self.boxView];
    
}

// 2. 绘制底板上小格子
- (void)drawBackCell
{
    for(int i=0;i<N;i++) // 行
    {
        for (int j=0; j<N; j++) // 列
        {
            // 格子位置 = 格子宽度 * j + 格子间隔 * j *2 + 盒子外围间隔
            CGFloat cellX = W(kCellWidth) * j + W(kCellPadding) * j * 2 + W(kCellPadding) + W(kBoxPadding);
            CGFloat cellY = H(kCellWidth) * i + H(kCellPadding) * i * 2 + H(kCellPadding) + H(kBoxPadding);
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX, cellY, W(kCellWidth), W(kCellWidth))];
            // 颜色
            cellView.backgroundColor = kRGBCellColor;
            // 圆角
            cellView.layer.cornerRadius = 3;
            [self.boxView addSubview:cellView];
        }
    }
}

#pragma mark - 2. 产生一个新的格子
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self addNewCell];
}

- (void)addNewCell
{
    // 1. 新格子产生位置
    int cellId = [self getEmptyCellId];
    if(cellId == -1)
    {
        return;
    }
    
    // 2. 产生一个数字
    int number = [self getNumber];
    
    // 3. 在该位置创建格子
    
    // 3.1 数据放到self.boxArr中保存
    self.boxArr[cellId] = @(number);
    [self printBoxArr];
    
    // 3.2 添加对应视图到界面
    [self createCellByCellId:cellId andNumber:number];
    
}

// 得到一个空格子的编号
- (int)getEmptyCellId
{
    // 那个地方不能已有格子
    // 从格子数据数组里找出所有空格子的编号，随机取一个
    
    // 1. 将所有空格子的编号，加入到一个数组
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i=0; i<N*N; i++)
    {
        if([self.boxArr[i] intValue] == 0)// 空格子
        {
            [tmpArr addObject:@(i)];
        }
    }
//    NSLog(@"空格子的编号的数组:%@",tmpArr);
    if(tmpArr.count<1)// 没有空格子了
    {
        return -1;
    }
    
    // 2. 从这个数组中随机选一个
    int rand = arc4random_uniform(tmpArr.count);
    
    // 3. 格子的编号
    int cellId = [tmpArr[rand] intValue];
    NSLog(@"随机得到空格子编号:cellId = %i",cellId);
    
    return cellId;
}

// 创建新单元格
- (void)createCellByCellId:(int)cellId andNumber:(int)number
{
    // 1. 创建
    CellView *cellView = [[CellView alloc] init];
    
    // 2. 设定坐标大小
    // 编号(0~15) -> 行号(0~3) 列号(0~3)
    int row = cellId / N;
    int col = cellId % N;
    CGFloat cellX = W(kCellWidth) * col + W(kCellPadding) * col * 2 + W(kCellPadding) + W(kBoxPadding);
    CGFloat cellY = H(kCellWidth) * row + H(kCellPadding) * row * 2 + H(kCellPadding) + H(kBoxPadding);
    cellView.frame = CGRectMake(cellX, cellY, W(kCellWidth), H(kCellWidth));
    
    // 3. 设定数字
    cellView.number = number;
    
    [self.boxView addSubview:cellView];
    
    // 4. 添加动画
    cellView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                           cellView.transform = CGAffineTransformMakeScale(1.2,1.2);
                        } completion:^(BOOL finished) {
                            cellView.transform = CGAffineTransformMakeScale(1,1);;
                        }];
    
    // 5. 设定tag
    cellView.tag = 100 + cellId;
    
}

// 随机产生4和2
- (int)getNumber
{
    if(arc4random_uniform(10) == 0) // 10% 概率产生4
    {
        return 4;
    }
    else // 90% 概率产生2
    {
        return 2;
    }
}

// 打印数据信息
- (void)printBoxArr
{
    for(int i=0;i<N;i++)
    {
        NSString *lineStr = [NSString stringWithFormat:@"%@ %@ %@ %@",self.boxArr[i*N+0],self.boxArr[i*N+1],self.boxArr[i*N+2],self.boxArr[i*N+3]];
        NSLog(@"%@",lineStr);
    }
}

#pragma mark 3. 移动
- (void)swipe:(UISwipeGestureRecognizer *)g
{
    // 向左滑动
    // 1 每行的处理相对独立
    // 2 从左向右逐个计算
    
    // 向右滑动
    // 1 每行的处理相对独立
    // 2 从右向左逐个计算
    
    // 上滑动
    // 1 每列相对独立计算
    // 2 从上往下计算
    
    // 下滑动
    // 1 每列相对独立计算
    

    switch (g.direction) {
        case UISwipeGestureRecognizerDirectionLeft: // 向左
        {
            for(int row= 0;row<N;row++)// 行
            {
                for(int col = 1;col<N;col++)// 列
                {
                    // 行和列 -> 编号
                    [self swipeCellLeftByCellId:(row*N+col)];
                }
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionRight: // 向右
        {
            for(int row= 0;row<N;row++)// 行
            {
                for(int col = N-2;col>=0;col--)// 列
                {
                    [self swipeCellLeftByCellId:(row*N+col)];
                }
            }
        }
            break;
            
            
        default:
            break;
    }
    
    // 添加新格子
//    [self addNewCell];
    [self performSelector:@selector(createNewCell) withObject:nil afterDelay:0.2];
}

- (void)createNewCell
{
    // 移除老视图
    for (UIView *view in self.needRemoveViewArr)
    {
        [view removeFromSuperview];
    }
    self.needRemoveViewArr = [NSMutableArray array];
 
    if(self.mergeCellIdArr.count>0)
    {
        [self playMergeSound];
    }
    else
    {
        [self playMoveSound];
    }
    // 产生合并的格子
    for (NSNumber *n in self.mergeCellIdArr)
    {
        int cellId = [n intValue];
        int cellNumber = [self.boxArr[cellId] intValue];
        
        [self createCellByCellId:cellId andNumber:cellNumber];
    }
    self.mergeCellIdArr = [NSMutableArray array];
    
    // 产生新格子
    
    [self addNewCell];
}

#pragma mark 单个单元格往某个方向
// 将某一个单元格往左方向滑动
- (void)swipeCellLeftByCellId:(int)cellId
{
    NSLog(@"%i",cellId);
    // 当前格子的位置x y
    int x = cellId/N; // 行
    int y = cellId%N; // 列
    
    // 当前格子里数字
    int curCellNumber = [self.boxArr[cellId] intValue];
    
    if(curCellNumber < 2)
    {
        return;
    }
    
    // 1. 前面没有数字的情况 移动到第一格
    // 2. 前面有数字
    //    1) 相同(但是前面那个数字不能是最新合并出来的)    -> 合并
    //    2) 不相同  -> 移动到它后面
    
    BOOL bEmpty = YES;// 前面没有格子
    for(int i = y-1;i>=0;i--) // 从这个格子的前一个格子开始往前面判断
    {
        if([self.boxArr[i+x*N] intValue]> 0)// 有数字
        {
            // 数字相等 且 前面那个数字不是合并出来的
            if(curCellNumber == [self.boxArr[i+x*N] intValue] && ![self.mergeCellIdArr containsObject:@(i+x*N)])
            {
                // 相同 -> 合并
                int toCellId = i+x*N;
                [self mergeCellFrom:cellId To:toCellId];
            }
            else
            {
                // 不同 -> 移动到它的后面一格
                // 移动到它的后面一格
                int toCellId = i+x*N + 1;
                if(toCellId != cellId)
                {
                    [self moveCellFrom:cellId To:toCellId];
                }
            }
            bEmpty = NO;
            break;
        }
    }
    
    if(bEmpty)
    {
        // 前面没有数字 -> 移动到最前面
        int toCellId = 0+x*N;
        [self moveCellFrom:cellId To:toCellId];
    }
    
}

- (void)swipeCellRightByCellId:(int)cellId

{
    
}
- (void)swipeCellUpByByCellId:(int)cellId

{
    
}
- (void)swipeCellDownByCellId:(int)cellId
{
    
}

#pragma mark 移动和合并
// 从fromCellId位置合并到toCellId的位置
- (void)mergeCellFrom:(int)fromCellId To:(int)toCellId
{
    NSLog(@"合并 %i到%i",fromCellId,toCellId);
    
    // 数据移动过去
    self.boxArr[toCellId] = @([self.boxArr[toCellId] intValue] * 2 ); // 新位置 * 2
    self.boxArr[fromCellId] = @(0);// 原先位置数据0
    
    // 视图
    
    // 在新的位置创建一个新格子，老格子移除
    CellView *fromCellView = [self.view viewWithTag:100+fromCellId];
    CellView *toCellView = [self.view viewWithTag:100+toCellId];
    
    NSLog(@"fromView = %@",fromCellView);
    NSLog(@"toView = %@",toCellView);
    // 加入到移除视图的列表
    [self.needRemoveViewArr addObject:fromCellView];
    [self.needRemoveViewArr addObject:toCellView];
    
    // 产生新格子的位置添加到列表
    [self.mergeCellIdArr addObject:@(toCellId)];
    
    // fromView 移动到新位置
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
     
                     animations:^{
                         int row = toCellId / N;
                         int col = toCellId % N;
                         CGFloat cellX = W(kCellWidth) * col + W(kCellPadding) * col * 2 + W(kCellPadding) + W(kBoxPadding);
                         CGFloat cellY = H(kCellWidth) * row + H(kCellPadding) * row * 2 + H(kCellPadding) + H(kBoxPadding);
                         fromCellView.frame = CGRectMake(cellX, cellY, W(kCellWidth), H(kCellWidth));
                     } completion:^(BOOL finished) {
                     }];
    
}

// 从某位置移动到某位置
- (void)moveCellFrom:(int)fromCellId To:(int)toCellId
{
    
    NSLog(@"移动%i到%i",fromCellId,toCellId);
    
    // 数据移动过去
    self.boxArr[toCellId] = self.boxArr[fromCellId];
    self.boxArr[fromCellId] = @(0);
    
    // 视图移动过去
    CellView *cellView = [self.boxView viewWithTag:100+fromCellId];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut

                     animations:^{
                        int row = toCellId / N;
                        int col = toCellId % N;
                        CGFloat cellX = W(kCellWidth) * col + W(kCellPadding) * col * 2 + W(kCellPadding) + W(kBoxPadding);
                        CGFloat cellY = H(kCellWidth) * row + H(kCellPadding) * row * 2 + H(kCellPadding) + H(kBoxPadding);
                        cellView.frame = CGRectMake(cellX, cellY, W(kCellWidth), H(kCellWidth));
                    } completion:^(BOOL finished) {
                        
                    }];
    cellView.tag = toCellId + 100;
    
}

#pragma mark - 4 添加音效
- (void)addSoundEffect
{
    NSURL *url1 =[[NSBundle mainBundle] URLForResource:@"merge" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)url1, &mergeSoundId);
    NSURL *url2 =[[NSBundle mainBundle] URLForResource:@"move" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)url2, &moveSoundId);
}

- (void)playMoveSound
{
    AudioServicesPlayAlertSound(moveSoundId);
}

- (void)playMergeSound
{
    AudioServicesPlayAlertSound(mergeSoundId);
}

@end
