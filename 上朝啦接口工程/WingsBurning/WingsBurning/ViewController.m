//
//  ViewController.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "Networking.h"
#import "NetModel.h"
#import "QiniuSDK.h"
#import "SHA1.h"
#import "CCLocationManager.h"
#import "UIColor+HexColor.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;

/**
 *  用于七牛传图的token
 */
@property(nonatomic,strong) ImageUploadToken *imageUploadToken;
/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *userYZM;

@property (nonatomic,strong) EmployeeM *employee;
@property (weak, nonatomic) IBOutlet UIImageView *testImgView;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLabel;
@property (weak, nonatomic) IBOutlet UILabel *gsBianHaoLabel;

@property (nonatomic,strong) TokensM *tokens;





@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    Networking *network = [Networking sharedNetwork];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#10e26f"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取验证码
 */
- (IBAction)huoQuYZM:(id)sender {

    [Networking huoQuYZM:self.userPhone.text successBlock:^{
        NSLog(@"获取成功");
    } failBlock:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];

}

/**
 * 刷新令牌
 */
- (IBAction)shuaXinLinPai:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    [Networking shuaXinLinPai:[ud objectForKey:@"refresh_token"] successBlock:^(NSArray *arr) {
        EmployeeM *employee = arr[0];
        TokensM *tokens = arr[1];
        self.tokens = tokens;
        self.employee = employee;
        [ud setObject:tokens.access_token forKey:@"access_token"];
        [ud setObject:tokens.refresh_token forKey:@"refresh_token"];
        NSLog(@"令牌刷新成功");
        NSLog(@"%@",tokens);
        NSLog(@"%@,%@",employee.name,employee.phone_number);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


/**
 *  登录
 *
 */
- (IBAction)dengLu:(id)sender {
    [Networking dengLu:self.userPhone.text yanZhenMa:self.userYZM.text successBlock:^(NSArray *arr) {
        EmployeeM *employee = arr[0];
        TokensM *tokens = arr[1];
        NSLog(@"%@,%@",employee.name,employee.phone_number);
        self.employee = employee;
        NSLog(@"%@",tokens);
        self.tokens = tokens;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:tokens.access_token forKey:@"access_token"];
        [ud setObject:tokens.refresh_token forKey:@"refresh_token"];

    } failBlock:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

/**
 *  注册
 *
 */
- (IBAction)zhuCe:(id)sender {
    Employees *emp = [[Employees alloc]init];
    emp.userName = self.userName.text;
    emp.phone_number = self.userPhone.text;
    emp.captcha = self.userYZM.text;
    [Networking zhuCe:emp successBlock:^(NSArray *arr) {
        EmployeeM *employee = arr[0];
        TokensM *tokens = arr[1];
        self.employee = employee;
        self.tokens = tokens;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:tokens.access_token forKey:@"access_token"];
        [ud setObject:tokens.refresh_token forKey:@"refresh_token"];
        NSLog(@"%@",arr);
        NSLog(@"注册成功");
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


/**
 *  打卡
 *
 */
- (IBAction)daKa:(id)sender {
    NSData *imgData = UIImageJPEGRepresentation(self.testImgView.image, 1.0);
    EmployeePunches *model = [[EmployeePunches alloc]init];
    model.imageHash = [SHA1 getSHA1:imgData];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

   [Networking daKa:model token:[ud objectForKey:@"access_token"] successBlock:^(PunchesModel *punModel) {
       ImageUploadToken *imgToken = punModel.image_upload_token;
       self.imageUploadToken = imgToken;
       NSLog(@"%@",imgToken);
       /**传图到七牛*/
       QNUploadManager *upManager = [[QNUploadManager alloc] init];
       QNUploadOption *option = [[QNUploadOption alloc]initWithMime:@"jpeg" progressHandler:nil params:nil checkCrc:false cancellationSignal:nil];
       [upManager putData:imgData key:imgToken.key token:imgToken.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
           NSLog(@"%@", resp);
           NSLog(@"打卡成功");
       } option:option];
   } failBlock:^(NSError *error) {
       NSLog(@"%@",error.localizedDescription);
   }];



}

/**
 *  打卡记录
 */
- (IBAction)daKaJiLu:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    EmployeeM *emp = self.employee;
    [Networking daKaJiLu:emp.ID token:token successBlock:^(PunchRecordM *punchRecord) {
        NSArray *punchArray = punchRecord.punchArray;
        PageM *page = punchRecord.page;
        NSLog(@"%@",page);
        NSLog(@"%@",punchArray);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}




/**
 *  上传到七牛云
 *
 */
/*
- (IBAction)shangChuanQiniu:(id)sender {
    //image转SHA1
    NSData *imgData = UIImageJPEGRepresentation(self.testImgView.image, 1.0);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *option = [[QNUploadOption alloc]initWithMime:@"jpeg" progressHandler:nil params:nil checkCrc:false cancellationSignal:nil];
    [upManager putData:imgData key:@"后台给key" token:@"后台给token" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
    } option:option];
}
*/




/**
 *  获取公司列表信息
 *
 */
- (IBAction)huoQuGSLBXX:(id)sender {
    Employers *emps = [[Employers alloc]init];
    emps.page = @(1);
    emps.per_page = @(2);
    emps.name = @"";
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [Networking huoQuGSLB:emps token:[ud objectForKey:@"access_token"] successBlock:^(NSArray *arr) {
        for (EmployeeM *emp in arr) {
            NSLog(@"%@,%@",emp.name,emp.ID);
            if ([emp.name isEqualToString:@"棉花糖"]) {
                self.gongsiLabel.text = emp.name;
                self.gsBianHaoLabel.text = emp.ID;
            }
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

/**
 *  公司信息
 *
 */
- (IBAction)huoQuGSXX:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    NSString *empID = self.gsBianHaoLabel.text;
    if (empID.length > 5) {
        [Networking chaXunGSXX:empID token:token successBlock:^(EmployerM *employer) {
            NSLog(@"%@,%@",employer.is_verified,employer.name);
        } failBlock:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }

}

/**
 *  雇员信息
 *
 */
- (IBAction)guYuanXinXi:(id)sender {
    EmployeeM *ee = [[EmployeeM alloc]init];
    ee.ID = self.employee.ID;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  [Networking huoQuGuYuanXinXi:ee.ID token:[ud objectForKey:@"access_token"] successBlock:^(EmployeeM *emp) {
      NSLog(@"%@,%@",emp.name,emp.phone_number);
  } failBlock:^(NSError *error) {
      NSLog(@"%@",error.localizedDescription);
      //422,合约已存在
  }];
}

/**
 *  更新雇员信息
 */
- (IBAction)gengXinGYXX:(id)sender {

    EmployeeM *ee = [[EmployeeM alloc]init];
    ee = self.employee;
    Employees *es = [[Employees alloc]init];
    es.userName = self.userName.text;
    es.phone_number = self.userPhone.text;
    es.captcha = self.userYZM.text;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    [Networking xiuGaiGuYuanXinXi:ee.ID Employees:es token:token successBlock:^(NSArray *array)
    {
        EmployeeM *employee = array[0];
        ImageUploadToken *imgUpTokens = array[1];
        NSLog(@"更新成功%@,%@",employee,imgUpTokens);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

/**
 *  申请加入公司
 */
- (IBAction)jiaRuGongSi:(id)sender {
    EmployerM *emp = [[EmployerM alloc]init];
    emp.ID = @"9bf512014b2d49bba68d9ab2558b841a";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [Networking chuangJianHeYue:emp.ID token:[ud objectForKey:@"access_token"] successBlock:^(ContractM *contract) {
        NSLog(@"申请加入公司成功%@",contract.ID);
        [ud setObject:contract.ID forKey:@"contractID"];
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

/**
 *  放弃申请加入公司
 *
 */
- (IBAction)fangQiJiaRuGongSi:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    NSString *contractID = [ud objectForKey:@"contractID"];
    [Networking cheXiaoCJHY:contractID token:token successBlock:^{
        NSLog(@"撤销申请加入公司");
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

/**
 *  离开公司
 *
 */
- (IBAction)liKaiGongSi:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    NSString *contractID = [ud objectForKey:@"contractID"];
    [Networking zhongZhiHeYue:contractID token:token successBlock:^{
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}



/**
 *  撤销离开公司
 *
 */
- (IBAction)fangQiLiKaiGongSi:(id)sender {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    NSString *contractID = [ud objectForKey:@"contractID"];
    [Networking chexiaoZZHY:contractID token:token successBlock:^{
        NSLog(@"成功撤销终止合约");
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


/**
 *  查看合约信息
 *
 */
- (IBAction)chaKanHeYue:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    [Networking huoQuDQHY:self.employee.ID token:token successBlock:^(ContractM *contract) {
        NSLog(@"%@",contract.state);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

/**
 *  根据编号查合约
 *
 */
- (IBAction)bianHaoChaHeYue:(id)sender {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    NSString *contractID = [ud objectForKey:@"contractID"];
    [Networking chaXunHeYue:contractID token:token successBlock:^(ContractM *contract) {
        NSLog(@"%@",contract.state);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}














@end
