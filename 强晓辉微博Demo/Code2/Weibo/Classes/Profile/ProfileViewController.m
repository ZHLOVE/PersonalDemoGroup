//
//  MeViewController.m
//  Weibo
//
//  Created by qiang on 4/21/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ProfileViewController.h"
#import "VisitorView.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![[UserAccount sharedUserAccount] isLogined])
    {
        [self.vistorView setupVisitorInfo:NO imageName:@"visitordiscover_image_profile" message:@"登录后,你的微博、相册、个人资料都会显示在这里."];
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
