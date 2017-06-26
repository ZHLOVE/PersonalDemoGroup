//
//  TableViewController.m
//  YLWeather
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//
// 练习
// 1. 制作一个全国天气应用
// http://flash.weather.com.cn/wmaps/xml/china.xml
//
// 第一页面显示全国省天气列表(表格)
// 点省后，显示这个省里城市的天气信息列表
// 点城市后,显示这个城市下区的信息列表

// 2. 解析NotesTestData.xml,用表格显示出来

#import "TableViewController.h"

#import "CityWeatherInfo.h"
#import "CellTableView.h"
static TableViewController *instance = nil;

@interface TableViewController ()<NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

//当前页面所有城市对象
@property (nonatomic,strong)NSMutableArray *cityList;
//当前页面URL
@property (nonatomic,strong)NSString *urlStr;
@property (nonatomic,copy)NSString *pyName;
@property (nonatomic,copy)NSString *naviItem;



@end

@implementation TableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"CellTableView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    if (self.pyName == nil) {
        self.urlStr = @"http://flash.weather.com.cn/wmaps/xml/china.xml";
        self.navigationItem.title = @"中华人民共和国官方天气预报";
    }else{
        NSMutableString *mStr = [@"http://flash.weather.com.cn/wmaps/xml/abc.xml" mutableCopy];
        NSRange range = [mStr rangeOfString:@"abc"];
        [mStr replaceCharactersInRange:range withString:self.pyName];
        self.urlStr = [mStr copy];
        self.navigationItem.title = self.naviItem;
    }

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlStr]];
    //解析容器
    NSXMLParser *parse = [[NSXMLParser alloc]initWithData:data];
    parse.delegate = self;
    [parse parse];
}


#pragma mark 解析XML
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析");
    self.cityList = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"city"]) {
        CityWeatherInfo *city = [CityWeatherInfo weatherInfoWithDict:attributeDict];
        [self.cityList addObject:city];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析结束");
    [self.tableView reloadData];
    NSLog(@"刷新表格");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CityWeatherInfo *cityInfo = self.cityList[indexPath.row];
    cell.cityCell = cityInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityWeatherInfo *cityInfo = self.cityList[indexPath.row];
    //到最后一级就不弹出页面了
    if (cityInfo.pyName.length>1) {
        TableViewController *cityVC2 = [[TableViewController alloc]init];
        NSLog(@"pyName%@",cityInfo.pyName);
        cityVC2.pyName = cityInfo.pyName;
        if (cityInfo.quName.length>1) {
            cityVC2.naviItem = cityInfo.quName;
        }else{
            cityVC2.naviItem = cityInfo.cityname;
        }
        
        [self.navigationController pushViewController:cityVC2 animated:YES ];
    }
    
}



@end
