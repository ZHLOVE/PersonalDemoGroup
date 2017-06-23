//
//  ViewController2.m
//  JSON
//
//  Created by niit on 16/3/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

#import "Video.h"

@interface ViewController2()<UITableViewDataSource,NSXMLParserDelegate>

@property(nonatomic,strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation ViewController2

- (void)viewDidLoad
{
    // 1. 获取数据
    NSString *urlStr = @"http://120.25.226.186:32812/video?type=XML";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];// 二进制数据
    
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",result);
    
    // 2. 创建一个解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    // 代理人
    parser.delegate = self;
    // 开始解析
    [parser parse];
    
    
    // 练习
    // 1. 制作一个全国天气应用
    // http://flash.weather.com.cn/wmaps/xml/china.xml
    //
    // 第一页面显示全国省天气列表(表格)
    // 点省后，显示这个省里城市的天气信息列表
    // 点城市后,显示这个城市下区的信息列表
    
    // 2. 解析NotesTestData.xml,用表格显示出来
    
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

#pragma mark - 解析的代理方法
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"解析开始了");
    self.list = [NSMutableArray array];
}

// 解析到某个标记
- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(nullable NSString *)namespaceURI
    qualifiedName:(nullable NSString *)qName
    attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    NSLog(@"解析到标记:%@",elementName);
    NSLog(@"属性:%@",attributeDict);
    if([elementName isEqualToString:@"video"])
    {
        NSLog(@"name:%@",attributeDict[@"name"]);
        NSLog(@"图片地址:%@",attributeDict[@"url"]);
        Video *v = [Video videoWithDict:attributeDict];
        [self.list addObject:v];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    NSLog(@"解析到标记结束:%@",elementName);
}

// <a href=@"http://baidu.com">百度</a> 解析到标记中的内容的时候
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%@",string);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"解析结束");
    [self.tableView reloadData];
}


@end
