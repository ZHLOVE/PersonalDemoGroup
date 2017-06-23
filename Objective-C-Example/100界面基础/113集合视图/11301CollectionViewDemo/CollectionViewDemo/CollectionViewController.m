//
//  CollectionViewController.m
//  CollectionViewDemo
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "CollectionViewController.h"

#import "CollectionViewCell.h"

#import "ViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

// 定义了一个静态不可变字符串变量
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 单元格模板
    // 1. Storyboard里的原型单元格 (Storyboard)
    // 2. registerClass注册       (纯代码)
    // 3. registerNib            (Xib)
    
    // 注册单元格模板
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

}

// 当沿着某条连线跳转时触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    segue.identifier
    
    NSLog(@"当前触发跳转的对象是:%@",sender);// 通过sender得到触发跳转的对象（就是当前你点击的单元格对象）
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];// 通过该对象得到他的NSIndexPath
    
    // 得到下一个页面
    ViewController *destVC = segue.destinationViewController;
    // 将全图片名字传递过去
    destVC.imageName = [NSString stringWithFormat:@"%i_full.JPG",indexPath.row];
}

#pragma mark <UICollectionViewDataSource> 数据源代理方法 为CollectionView提供数据信息

// 1. 有几段?
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 2. 某段有几项?
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 32;
}

// 3. 某段某项单元格内容?
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    // 文字
    cell.label.text = [NSString stringWithFormat:@"%i.JPG",indexPath.row];
    // 图片
    cell.imageView.image = [UIImage imageNamed:cell.label.text];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate> 事件代理方法,为CollectionView提供事件处理

// 1. 选中、高亮相关

// 将要高亮
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:(%li,%li)",__func__,indexPath.section,indexPath.row);
	return YES;
}

// 将要选中
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:(%li,%li)",__func__,indexPath.section,indexPath.row);
    return YES;
}

// 将要取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:(%li,%li)",__func__,indexPath.section,indexPath.row);
    return YES;
}

// 已经选中(如果有segue跳转，该方法发生在跳转之后)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:(%li,%li)",__func__,indexPath.section,(long)indexPath.row);
}

// 2. 当用户长按Cell时，会显示编辑菜单,用于复制、粘贴Cell
/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

