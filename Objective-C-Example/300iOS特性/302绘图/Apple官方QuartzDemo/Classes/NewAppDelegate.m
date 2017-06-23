//
//  NewAppDelegate.m
//  QuartzDemo
//
//  Created by niit on 16/4/6.
//
//

#import "NewAppDelegate.h"

#import "MainViewController.h"

@implementation NewAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navi;
    
    
    return YES;
}

@end
