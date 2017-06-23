//
//  LeftViewController.m
//  MyParse
//
//  Created by niit on 16/4/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"

#import "MainViewController.h"
#import "AboutViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *list;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.list = @[@"主界面",@"关于",@"退出"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    MMDrawerController *drawerController = appDelegate.window.rootViewController;
    
    switch (indexPath.row)
    {
        case 0:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *mainVC = [sb instantiateViewControllerWithIdentifier:@"MainViewController"];
            UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:mainVC];
            drawerController.centerViewController = mainNavi;
            [drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
            break;
        case 1:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *aboutVC = [sb instantiateViewControllerWithIdentifier:@"AboutViewController"];
            UINavigationController *aboutNavi = [[UINavigationController alloc] initWithRootViewController:aboutVC];
            drawerController.centerViewController = aboutNavi;
            [drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
            
            break;
        case 2:
        {
            NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
            [d setBool:NO forKey:@"logined"];
            [d synchronize];
            [appDelegate loadLoginController];
        }
            break;
        default:
            break;
    }
}
@end
