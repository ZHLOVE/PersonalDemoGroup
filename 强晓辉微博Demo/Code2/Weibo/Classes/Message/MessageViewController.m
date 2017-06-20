//
//  MessageViewController.m
//  Weibo
//
//  Created by qiang on 4/21/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "MessageViewController.h"

#import "VisitorView.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![[UserAccount sharedUserAccount] isLogined])
    {
        [self.vistorView setupVisitorInfo:NO imageName:@"visitordiscover_image_message" message:@"登陆后,比人评论你的微博,发给你的消息，都会在这里收到通知."];
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
