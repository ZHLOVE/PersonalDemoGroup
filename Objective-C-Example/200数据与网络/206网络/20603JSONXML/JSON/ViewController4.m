//
//  ViewController4.m
//  JSON
//
//  Created by niit on 16/3/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController4.h"

#import "TBXML.h"

#import "Video.h"

@interface ViewController4()<UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
@implementation ViewController4

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 获取数据
    NSString *urlStr = @"http://120.25.226.186:32812/video?type=XML";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];// 二进制数据
    
    // 2. 解析数据
    
    // 创建TBXML对象
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:nil];
    // 得到根节点
    TBXMLElement *root = xml.rootXMLElement;
    
    self.list = [NSMutableArray array];
    if(root)
    {
        // 得到root的第一个“video”的子节点
        TBXMLElement *childElement = [TBXML childElementNamed:@"video" parentElement:root];
        
        while (childElement != nil)
        {
            // 得到节点里的文本内容
//            NSString *text = [TBXML textForElement:@"childElement"];// <a href="http://www.baidu.com">百度</a> => 百度
            
            // 得到这个节点里的属性值
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:childElement];
            NSString *image = [TBXML valueOfAttributeNamed:@"image" forElement:childElement];
            NSString *url = [TBXML valueOfAttributeNamed:@"url" forElement:childElement];
            
            // 将信息放入模型,添加到数组
            Video *v = [[Video alloc] init];
            v.name = name;
            v.image = image;
            v.url = url;
            [self.list addObject:v];
            
            // 查找下一个相邻video节点
            childElement = [TBXML nextSiblingNamed:@"video" searchFromElement:childElement];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Video *v = self.list[indexPath.row];
    cell.textLabel.text = v.name;
    cell.detailTextLabel.text = v.url;
    
    NSString *imageUrlStr = [@"http://120.25.226.186:32812/" stringByAppendingString:v.image];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlStr]];// 获取图片数据,当前是同步请求方式，会卡，需要改进成异步
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;
    
    return cell;
}
@end
