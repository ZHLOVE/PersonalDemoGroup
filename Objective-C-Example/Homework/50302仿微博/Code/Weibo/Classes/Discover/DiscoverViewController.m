//
//  DiscoverViewController.m
//  Weibo
//
//  Created by qiang on 4/21/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "DiscoverViewController.h"

#import "VisitorView.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(![[UserAccount sharedUserAccount] isLogined])
    {
        [self.vistorView setupVisitorInfo:NO imageName:@"visitordiscover_feed_image_house" message:@"登陆后，最新最热的微博显示在这里!"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

@end
