//
//  CollectionViewController.m
//  CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CollectionViewController.h"

#import "CollectionViewCell.h"
#import "ViewController.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
//    [ tionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//沿着连线跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //获取到当前点击的cell的indexPath
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    ViewController *destVC = segue.destinationViewController;
    destVC.imageName = [NSString stringWithFormat:@"%i_full.JPG",indexPath.row];
}


#pragma mark <UICollectionViewDataSource>




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.label.text = [NSString stringWithFormat:@"%i.JPG",indexPath.row];
    cell.imageView.image = [UIImage imageNamed:cell.label.text];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
