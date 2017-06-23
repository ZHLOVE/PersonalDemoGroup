//
//  ViewController.m
//  TestLeak
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"


#import "Father.h"
#import "Child.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *fatherList;
@property (nonatomic,strong) NSMutableArray *childList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.fatherList = [NSMutableArray array];
    self.childList = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addBtnPressed:(id)sender
{
    Father *father = [[Father alloc] init];
    Child *child = [[Child alloc] init];
    
    father.myChild = child;
    child.myFather = father;
    
    [self.fatherList addObject:father];
    [self.childList addObject:child];
    
}
- (IBAction)removeBtnPressed:(id)sender {
    
    [self.fatherList removeLastObject];
    [self.childList removeLastObject];
    
}

@end
