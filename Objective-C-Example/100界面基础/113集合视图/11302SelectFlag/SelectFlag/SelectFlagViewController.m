//
//  SelectFlagViewController.m
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SelectFlagViewController.h"

#import "FlagModel.h"
#import "FlagCell.h"

#import "SectionHeader.h"

@interface SelectFlagViewController ()

// 洲名数组
@property (nonatomic,strong) NSArray *continentNameArrs;
// 以洲名为key的国旗数组字典
@property (nonatomic,strong) NSDictionary *flagsArrDict;

@end

@implementation SelectFlagViewController

static NSString * const reuseIdentifier = @"FlagCell";

- (NSArray *)continentNameArrs
{
    if(_continentNameArrs == nil)
    {
        _continentNameArrs = @[@"African Flags",@"Asian Flags",@"Australasian Flags",@"European Flags",@"North American Flags",@"South American Flags"];
    }
    return _continentNameArrs;
}

- (NSDictionary *)flagsArrDict
{
    if(_flagsArrDict == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"flag" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        
        int i=0;
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        for (NSArray *tmpArr in arr)
        {
            // 1. 将每个洲里国家国旗信息的数组放入一个数组
            NSMutableArray *mArr1 = [NSMutableArray array];
            for(NSDictionary *dict in tmpArr)
            {
                FlagModel *f = [FlagModel flagWithDict:dict];
                [mArr1 addObject:f];
            }
            
            // 2. 以洲名为key将数组存入一个的字典
            NSString *continentName = self.continentNameArrs[i++];
            mDict[continentName] = mArr1;
        }
        _flagsArrDict = mDict;
    }
    return _flagsArrDict;
}


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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = self.flagsArrDict[self.continentNameArrs[section]];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *continentName = self.continentNameArrs[indexPath.section];
    NSArray *arr = self.flagsArrDict[continentName];
    FlagModel *flag = arr[indexPath.row];
    cell.flag = flag;
    
    return cell;
}

// 为辅助视图提供数据
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        // 查找可复用的段头
        SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        // 修改内容
        NSString *continentName = self.continentNameArrs[indexPath.section];
        header.label.text = continentName;
        
        return header;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 得到当前点选国家的信息
    NSString *continentName = self.continentNameArrs[indexPath.section];
    NSArray *flagsArr = self.flagsArrDict[continentName];
    FlagModel *flag = flagsArr[indexPath.row];
    
    // 把flag信息传递到前一个页面
    
    // 3. 调用代理人执行代理方法，将数据传递回去
    [self.delegate changeFlag:flag];
    
    // 把当前页面给dismis掉
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
