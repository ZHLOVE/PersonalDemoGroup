//
//  VideoListBaseViewController.h
//  HiTV
//
//  created by iSwift on 3/9/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视频列表基类，如收藏，最近访问，搜索，点播相关页面等
 */
@interface BaseVideoListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* videosArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@property (nonatomic, assign) BOOL editing;
@property (strong, nonatomic) IBOutlet UILabel* tipLab;
@property (strong, nonatomic) IBOutlet UIImageView* tipImg;

- (void)removeAllVideos;

//删除的索引
//- (void)removeVideosWithArray:(NSArray *)indexAry;

@property (strong, nonatomic) UIView* editView;

@end
