//
//  ChangeLangunge.m
//  11402PresidentList
//
//  Created by 马千里 on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ChangeLangunge.h"


#import "LangungeTableViewCell.h"
#import "President.h"

@interface ChangeLangunge ()<UITableViewDelegate>

@property (nonatomic,strong) NSArray *langungeArray;

@end

@implementation ChangeLangunge

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.langungeArray = @[@"简中-zh",@"English-en",@"France-fr",@"German-de",@"Spain-es",@"Japan-ja",@"Korea-ko"];
    // 1.创建一个Nib对象 2.注册表格单元格的模板,(dequeueReusableCellWithIdentifier查找可复用单元格查找不到，则自动用单元格模板创建新单元格)
    UINib *nib = [UINib nibWithNibName:@"LangungeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"langungeCell"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.langungeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LangungeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"langungeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.langungeArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableString *langunge = [self.langungeArray[indexPath.row]mutableCopy];
    langunge = [langunge substringFromIndex:langunge.length-2] ;
    NSMutableString *curUrl = [self.preDetail.webUrl mutableCopy];
    [curUrl replaceCharactersInRange:NSMakeRange(7, 2) withString:langunge];
//     NSLog(@"%@",curUrl);
    self.preDetail.webUrl = curUrl;
   
    //    [self.preDetail.popVC dismissPopoverAnimated:YES]; //点击后隐藏下拉列表
}


@end
