//
//  DogListViewController.m
//  带狗狗散步
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DogListViewController.h"

#import "AppDelegate.h"
#import "Dog.h"

#import "DogWallsViewController.h"


@interface DogListViewController ()
{
    Dog *curDog;
}

@property (nonatomic,weak) AppDelegate *appDelegate;

@property (nonatomic,strong) NSMutableArray *dogs;

@end

@implementation DogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 得到AppDelegate
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    // 查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 查询的实体对象类型
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dog" inManagedObjectContext:self.appDelegate.managedObjectContext];
    request.entity = entity;
    
    NSArray *dogs = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    if(dogs.count < 1)
    {
        // 数据库是空的,创建2条狗
        self.dogs = [NSMutableArray array];
        
        Dog *dog = [NSEntityDescription insertNewObjectForEntityForName:@"Dog" inManagedObjectContext:self.appDelegate.managedObjectContext];
        dog.name = @"小白";
        dog.image = @"dog1.png";
        [self.dogs addObject:dog];
        
        dog = [NSEntityDescription insertNewObjectForEntityForName:@"Dog" inManagedObjectContext:self.appDelegate.managedObjectContext];
        dog.name = @"阿黄";
        dog.image = @"dog2.png";
        [self.dogs addObject:dog];
        
        [self.appDelegate saveContext];
    }
    else
    {
        self.dogs = [dogs mutableCopy];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 将狗的信息传递给下一个页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@",sender);
    UITableViewCell *cell = sender;
    DogWallsViewController *destVC = segue.destinationViewController;
    destVC.dog = self.dogs[cell.tag];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Dog *d = self.dogs[indexPath.row];
    cell.textLabel.text = d.name;
    cell.imageView.image = [UIImage imageNamed:d.image];
    cell.tag = indexPath.row;
    
    return cell;
}

@end
