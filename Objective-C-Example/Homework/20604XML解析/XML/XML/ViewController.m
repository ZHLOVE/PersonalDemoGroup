//
//  ViewController.m
//  XML
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "Video.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1获取数据
    NSString *urlStr = @"http://120.25.226.186:32812/video?type=XML";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    //2创建一个解析容器
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    [parser parse];
    
}

#pragma mark - 解析的代理方法
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"解析开始");
    self.list = [NSMutableArray array];
}
//解析标记
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(nullable NSString *)namespaceURI
                                        qualifiedName:(nullable NSString *)qName
                                        attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{

    NSLog(@"解析到的标记%@",elementName);
    NSLog(@"属性%@",attributeDict);
    if ([elementName isEqualToString:@"video"]) {
        NSLog(@"name:%@",attributeDict[@"name"]);
        NSLog(@"图片地址:%@",attributeDict[@"url"]);
        Video *v = [Video videoWithDict:attributeDict];
        [self.list addObject:v];
    }
    
}

//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
//{
//    NSLog(@"解析到标记结束:%@",elementName);
//}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析结束");
    [self.tableView reloadData];
}

// <a href=@"http://baidu.com">百度</a> 解析到标记中的内容的时候
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"内容%@",string);
}




#pragma mark 表格显示
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
