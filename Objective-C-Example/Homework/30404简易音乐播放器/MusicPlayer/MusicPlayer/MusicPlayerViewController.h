//
//  MusicPlayerViewController.h
//  MusicPlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Singleton.h"
#import "Music.h"

@interface MusicPlayerViewController : UIViewController
SingletonH(MusicPlayerViewController)
@property (nonatomic,strong)NSArray *musicArray;
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,weak)Music *music;

@end
