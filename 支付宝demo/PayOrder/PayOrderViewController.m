//
//  ViewController.m
//  PayOrder
//
//  Created by MBP on 16/6/30.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PayOrderViewController.h"

@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *payTab;
@property(nonatomic,strong) UIColor *mainLightGrey;
@property(nonatomic,strong) UIColor *mainOrange;
@property(nonatomic,assign) int orderPrice;//订单支付金额
@property(nonatomic,copy) NSString *orderN;//订单编号
@property(nonatomic,copy) NSString *alipayRes;//支付宝支付参数
@property(nonatomic,strong) NSArray *contentArr;



@end


@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = self.mainLightGrey;
    self.title = @"支付订单";
    [self setUI];
}

#pragma mark UITable代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *reuserID = [NSString stringWithFormat:@"payOrderCell%lu",indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserID];
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        case 1:{
            UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 16.5, 100, 15)];
            labelTitle.text = self.contentArr[indexPath.row][0];
            NSLog(@"%@",labelTitle.text);
            labelTitle.textColor = [UIColor grayColor];
            labelTitle.font = [UIFont systemFontOfSize:15];
            [cell addSubview:labelTitle];

            UILabel *labelContent = [[UILabel alloc]initWithFrame:CGRectMake(labelTitle.frame.origin.x + labelTitle.frame.size.width + 10,
                                                                             16.5,
                                                                             self.payTab.frame.size.width - labelTitle.frame.size.width - 30,
                                                                             15)];
            labelContent.text = self.contentArr[indexPath.row][1];
            labelContent.textAlignment = NSTextAlignmentRight;
            labelContent.font = [UIFont systemFontOfSize:15];
            [cell addSubview:labelContent];

            UIView *fenGeLine = [[UIView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height, self.payTab.frame.size.width - 10, 1)];
            [cell addSubview:fenGeLine];
            if (indexPath.row == 0) {
                labelContent.textColor = [UIColor blackColor];
                fenGeLine.backgroundColor = [UIColor lightGrayColor];
            }else{
                labelContent.textColor = self.mainOrange;
                fenGeLine.backgroundColor = [UIColor clearColor];
            }
        }
            break;
        case 2:
        {
            cell.backgroundColor = [UIColor clearColor];
            UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 19, self.payTab.frame.size.width - 20, 11)];
            labelTitle.text = self.contentArr[indexPath.row][0];
            labelTitle.font = [UIFont systemFontOfSize:11];
            labelTitle.textColor = [UIColor grayColor];
            [cell addSubview:labelTitle];
        }
            break;
        case 3:
        {
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6.5, 35, 35)];
            iconView.backgroundColor = [UIColor greenColor];
            NSString *imgName = self.contentArr[indexPath.row][1];
            iconView.image = [UIImage imageNamed:imgName];
            iconView.layer.cornerRadius = 7;
            [cell addSubview:iconView];

            UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 8, 18, self.payTab.frame.size.width - 10 - iconView.frame.size.width, 14)];
            labelTitle.text = self.contentArr[indexPath.row][0];
            labelTitle.textColor = [UIColor grayColor];
            labelTitle.font = [UIFont systemFontOfSize:14];
            [cell addSubview:labelTitle];
        }
            break;
        case 4:
        {
            cell.backgroundColor = [UIColor clearColor];
            UIButton *btnPay = [[UIButton alloc]initWithFrame:CGRectMake(10, 29, self.payTab.frame.size.width - 20,42)];
            btnPay.backgroundColor = self.mainOrange;
            NSString *title = self.contentArr[indexPath.row][0];
            [btnPay setTitle:title forState:UIControlStateNormal];
            [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnPay.titleLabel.font = [UIFont systemFontOfSize:16];
            btnPay.layer.cornerRadius = 5;
            [btnPay addTarget:self action:@selector(payforClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnPay];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:return 48;break;
        case 1: return 48; break;
        case 4: return 100;break;
        default: return 48;break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //支付宝标准回调
}

#pragma mark 准备支付
- (void)payforClick{
    NSLog(@"准备支付");
}

#pragma mark UI布局
- (void)setUI{
    self.payTab.frame = CGRectMake(0, 0,self.view.bounds.size.width,self.view.bounds.size.height);
    self.payTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.payTab];
}

#pragma mark 懒加载

- (UITableView *)payTab{
    if (_payTab == nil) {
        _payTab = [[UITableView alloc]init];
        _payTab.scrollEnabled = YES;
        _payTab.delegate = self;
        _payTab.dataSource = self;
        _payTab.backgroundColor = self.mainLightGrey;
        _payTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _payTab;
}



#pragma mark 懒加载
- (UIColor *)mainLightGrey{
    if (_mainLightGrey == nil) {
        _mainLightGrey = [[UIColor alloc]init];
        _mainLightGrey = [self colorWithRGBValue:0xefeff4];
    }
    return _mainLightGrey;
}

- (UIColor *)mainOrange{
    if (_mainOrange == nil) {
        _mainOrange = [[UIColor alloc]init];
        _mainOrange = [self colorWithRGBValue:0xffb400];
    }
    return _mainOrange;
}

- (NSArray *)contentArr{
    if (_contentArr == nil) {

        _contentArr = @[@[@"订单号",@"20160630328576684638"],
                       @[@"支付金额",@"1.00元"],
                        @[@"支付方式:",@""],
                        @[@"支付宝快捷支付",@"icon_zfb@2x"],
                        @[@"确认支付",@""]];
    }
    return _contentArr;
}
#pragma mark UIColor
//此处的颜色应该用Category，这里图省事就先这么写着
- (UIColor *)colorWithRGBValue:(uint)rgbValue{
    CGFloat red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((rgbValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue = (rgbValue & 0x0000FF) / 255.0;
    CGFloat alpha = 1.0;

    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return  color;
}
@end
