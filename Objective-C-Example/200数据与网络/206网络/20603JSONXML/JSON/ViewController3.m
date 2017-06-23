//
//  ViewController3.m
//  JSON
//
//  Created by niit on 16/3/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController3.h"

#import "Note.h"

@interface ViewController3()<UITableViewDataSource,NSXMLParserDelegate>
{
    NSString *curElemnet;// 当前标记
    NSString *date;
    NSString *content;
    NSString *userID;
    
    NSString *tmpString;//
    
}

@property(nonatomic,strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
@implementation ViewController3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"NotesTestData" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSLog(@"%i",data.length);
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}

#pragma mark -

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
    Note *n = self.list[indexPath.row];
    cell.textLabel.text = n.Content;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",n.UserID,n.CDate];
    return cell;
}

#pragma mark -
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析了");
    self.list = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
//    NSLog(@"%@",elementName);
    // 记录当前解析到哪个标记
    curElemnet = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"%@",string);
    // 临时保存一下标记里括起来的内容
    tmpString = string;
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    if([elementName isEqualToString:@"CDate"])
    {
        date = tmpString;
    }
    else if([elementName isEqualToString:@"Content"])
    {
        content = tmpString;
    }
    else if([elementName isEqualToString:@"UserID"])
    {
        userID = tmpString;
    }
    
    // 当解析到</Note> 保存这个Note的信息
    if([elementName isEqualToString:@"Note"])
    {
        Note *n = [[Note alloc] init];
        n.CDate = date;
        n.Content = content;
        n.UserID = userID;
        [self.list addObject:n];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"全部解析结束了，刷新界面");
    [self.tableView reloadData];
}

@end
