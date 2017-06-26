//
//  CollectionViewController.m
//  Flag_CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CollectionViewController.h"

#import "CollectionViewCell.h"
#import "FlagData.h"
@interface CollectionViewController ()

//@property(nonatomic,strong) NSArray *name;
//@property(nonatomic,strong) NSArray *imageName;

// 洲名数组
@property (nonatomic,strong) NSArray *continentNameArrs;
// 以洲名为key的国旗数组字典
@property (nonatomic,strong) NSDictionary *flagsArrDict;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 修改CollectionView布局
    
    // 创建一个新的流布局对象
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    // 单元格的尺寸
    fl.itemSize = CGSizeMake(150, 120);
    // 段之间间距
    //    fl.minimumLineSpacing = 100.0;
    // Cell之间的间距
    fl.minimumInteritemSpacing = 10.0;
    // 滑动方向
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 段头大小
    fl.headerReferenceSize = CGSizeMake(100, 75);
    // 段尾大小
    fl.footerReferenceSize = CGSizeMake(100, 75);
    
    self.collectionView.collectionViewLayout = fl;
    
    // 为CollectionView的段头创建模板
    // 如果在Storyboard中设计了段头,则不需要该行代码
    //[self.collectionView registerClass:[SectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];



}

- (NSArray *)continentNameArrs
{
   
    if(_continentNameArrs == nil)
    {
        _continentNameArrs = @[@"African Flags",@"Asian Flags",@"Australasian Flags",@"European Flags",@"North American Flags",@"South American Flags"];
    }
    return _continentNameArrs;
}

- (NSDictionary *)flagsArrDict{
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flag" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *mCountryArray = [NSMutableArray array];
    NSMutableDictionary *mCountryDict = [NSMutableDictionary dictionary];
    
    if (_flagsArrDict == nil) {
       
        int i=0;
        for (NSArray *tmpArray in array) {
            for (NSDictionary *d in tmpArray) {
                //数据模型
                FlagData *flag = [FlagData flagWithDict:d];
                [mCountryArray addObject:flag];
            }
            NSString *continentName = self.continentNameArrs[i++];
            mCountryDict[continentName] = mCountryArray;
        }
        _flagsArrDict = mCountryDict;
    }
    //不能用self.flagsArrDict,会造成死循环
    return _flagsArrDict;
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
    return 6;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    NSArray * array = self.flagsArrDict[self.continentNameArrs[section]];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *continentName = self.continentNameArrs[indexPath.section];
    NSArray *array = self.flagsArrDict[continentName];
    cell.flag = array[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 得到当前点选国家的信息
    NSString *continentName = self.continentNameArrs[indexPath.section];
    NSArray *flagsArr = self.flagsArrDict[continentName];
    FlagData *flag = flagsArr[indexPath.row];
    
    // 把flag信息传递到前一个页面
    
    // 调用代理人执行代理方法，将数据传递回去
    [self.delegate changeFlag:flag];
    
    //2当前页面dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>



@end
