//
//  TableViewController.m
//  11214
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewController.h"

#import "Constellation.h"
#import "TableViewCell.h"
@interface TableViewController ()

@property (nonatomic,strong) NSArray *constellationArray;

@end

@implementation TableViewController

//懒加载
- (NSArray *)constellationArray{
    if (_constellationArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"constellation" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            Constellation *c = [Constellation ConstellationWithDict:dict];
            [mArray addObject:c];
        }
        _constellationArray = [mArray copy];
    }
    return _constellationArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.constellationArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.constellation = self.constellationArray[indexPath.row];
    
    return cell;
}



@end
