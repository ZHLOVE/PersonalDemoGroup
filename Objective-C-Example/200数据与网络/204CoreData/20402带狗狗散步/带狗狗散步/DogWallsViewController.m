//
//  ViewController.m
//  带狗狗散步
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DogWallsViewController.h"

#import "AppDelegate.h"
#import "Walk.h"

@interface DogWallsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak) AppDelegate *appDelegate;
@end

@implementation DogWallsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.imageView.image = [UIImage imageNamed:self.dog.image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWalk:(id)sender
{
    Walk *w = [NSEntityDescription insertNewObjectForEntityForName:@"Walk" inManagedObjectContext:self.appDelegate.managedObjectContext];
    w.date = [NSDate date];
    [self.dog addWalksObject:w];
    [self.appDelegate saveContext];
    
    // 方法1: 刷新一下
//    [self.tableView reloadData];
    // 方法2:
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dog.walks.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dog.walks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Walk *walk = [self.dog.walks allObjects][indexPath.row];
    NSDate *date = walk.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.textLabel.text = [df stringFromDate:date];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    NSArray *walks = [self.dog.walks allObjects];
    Walk *walk = walks[row];
    
    [self.dog removeWalksObject:walk];
    [self.appDelegate.managedObjectContext deleteObject:walk];
    
    
    [self.appDelegate saveContext];
    
//    [self.tableView reloadData];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

@end
