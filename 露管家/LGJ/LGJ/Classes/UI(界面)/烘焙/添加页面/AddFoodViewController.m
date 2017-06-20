//
//  AddFoodViewController.m
//  LGJ
//
//  Created by student on 16/5/13.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "AddFoodViewController.h"
#import "ActionSheetPicker.h"




// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@interface AddFoodViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UILabel *foodInfoLabel; //食物信息
@property (strong, nonatomic)  UIImageView *foodImg; //食物图片
@property (nonatomic,copy) NSString *imgStrPath;
@property (strong, nonatomic)  UILabel *nameLabel; //名称
@property (strong, nonatomic)  UILabel *typeLabel; //类别
@property(nonatomic,strong) UITextField *nameTextField;//名称输入框
@property(nonatomic,strong) UITextField *typeTextField;//类别输入框

@property (strong, nonatomic)  UIButton *dayFromBtn; //生产日期
@property (strong, nonatomic)  UIButton *dayToBtn; //到期日期
@property (strong, nonatomic)  UILabel *dayFromLabel; //生产日期
@property (strong, nonatomic)  UILabel *dayToLabel; //到期日期

@property (weak, nonatomic) IBOutlet UILabel *dayLabel; //保质时间
@property (weak, nonatomic) IBOutlet UILabel *foodCountLabel; //数量
//@property (weak, nonatomic) IBOutlet UILabel *countLabel;//1个
@property (nonatomic,strong) UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper; //数量加减按钮
@property (weak, nonatomic) IBOutlet UILabel *comLabel; //备注

@end

@implementation AddFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}


- (void)setModel:(DataModel *)model{
    //沙盒读取图片
    _model = model;
    NSString *imgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ]stringByAppendingPathComponent:model.image];
    self.foodImg.image = [[UIImage alloc]initWithContentsOfFile:imgPath];
    self.nameTextField.text = model.name;
    self.typeTextField.text = model.type;
    [self.dayFromBtn setTitle:model.dayFrom forState:UIControlStateNormal];
    [self.dayToBtn setTitle:model.dayTo forState:UIControlStateNormal];
    self.countLabel.text = model.counts; //1个
//    self.stepper.value = [model.counts intValue];
}





#pragma mark 设置UI
- (void)setUI{
    //设置navigation Ttile
    if (self.model) {
        self.navigationItem.title = @"烘焙材料";
    }else{
        self.navigationItem.title = @"添加烘焙材料";
    }
    //添加控件
    [self.view addSubview:self.foodInfoLabel]; //食物信息
    [self.view addSubview:self.foodImg]; //食物图片
    [self.view addSubview:self.nameLabel]; //名字
    [self.view addSubview:self.typeLabel]; //类型
    [self.view addSubview:self.nameTextField]; //名字文本
    [self.view addSubview:self.typeTextField]; //类型文本
    //分割线
    [self line:self.foodImg.bottom];
    [self.view addSubview:self.dayFromLabel]; //生产日期
    [self.view addSubview:self.dayFromBtn];  //生产日期按钮
    [self.view addSubview:self.dayToLabel];  //保质到期
    [self.view addSubview:self.dayToBtn];   //保质日期按钮
    [self.view addSubview:self.countLabel]; //1个
    //分割线
    [self line:self.dayToLabel.bottom];
    [self line:self.countLabel.bottom];
    [self setUIStepper];//设置stepper初始值
    
    
#pragma mark 约束
    //布局
    [self.foodInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80);
        make.height.equalTo(20);
        make.left.equalTo(30);
        make.top.equalTo(80);
    }];
    [self.foodImg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenW*0.3);
        make.height.equalTo(kScreenW*0.3);
        make.top.equalTo(self.foodInfoLabel.bottom).offset(10);
        make.left.equalTo(self.foodInfoLabel.left).offset(-5);
    }];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(20);
        make.left.equalTo(self.foodImg.right).offset(10);
        make.top.equalTo(self.foodImg.top).offset(20);
    }];
    [self.typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(20);
        make.left.equalTo(self.foodImg.right).offset(10);
        make.bottom.equalTo(self.foodImg.bottom).offset(-20);
    }];
    [self.nameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20);
        make.left.equalTo(self.nameLabel.right).offset(10);
        make.top.equalTo(self.nameLabel.top);
        make.right.equalTo(0).offset(-20);
    }];
    [self.typeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20);
        make.left.equalTo(self.typeLabel.right).offset(10);
        make.top.equalTo(self.typeLabel.top);
        make.right.equalTo(0).offset(-20);
    }];
    [self.dayFromBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenW*0.5);
        make.height.equalTo(20);
        make.right.equalTo(0).offset(-20);
        make.top.equalTo(self.dayFromLabel.top);
    }];
    [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.foodInfoLabel.width);
        make.height.equalTo(self.foodInfoLabel.height);
        make.top.equalTo(self.foodImg.bottom).offset(30);
        make.left.equalTo(self.foodImg.left).offset(5);
    }];
    
    [self.dayFromLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.foodImg.width);
        make.height.equalTo(20);
        make.right.equalTo(self.foodImg.right);
        make.top.equalTo(self.dayLabel.bottom).offset(10);
    }];
    [self.dayToBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.dayFromBtn);
        make.height.equalTo(self.dayFromBtn);
        make.left.equalTo(self.dayFromBtn.left);
        make.top.equalTo(self.dayToLabel.top);
    }];
    [self.dayToLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.dayFromLabel);
        make.height.equalTo(self.dayFromLabel);
        make.right.equalTo(self.foodImg.right);
        make.top.equalTo(self.dayFromLabel.bottom).offset(20);
    }];
    [self.foodCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.foodInfoLabel.width);
        make.height.equalTo(self.foodInfoLabel.height);
        make.top.equalTo(self.dayToLabel.bottom).offset(30);
        make.left.equalTo(self.foodImg.left).offset(5);
    }];
    [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(30);
        make.height.equalTo(20);
        make.top.equalTo(self.foodCountLabel.top);
        make.right.equalTo(self.dayToLabel.right);
    }];
    [self.stepper makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.foodCountLabel.centerY);
        make.right.equalTo(0).offset(-50);
    }];
    [self.comLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.foodInfoLabel.width);
        make.height.equalTo(self.foodInfoLabel.height);
        make.top.equalTo(self.foodCountLabel.bottom).offset(30);
        make.left.equalTo(self.foodImg.left).offset(5);
    }];
    
}

//分割线
- (void)line:(id)view{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,10,100,10)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.width.equalTo(kScreenW);
        make.left.equalTo(0);
        make.top.equalTo(view).offset(15);
    }];
}

#pragma mark - 懒加载
- (UILabel *)foodInfoLabel{
    if (_foodInfoLabel == nil) {
        _foodInfoLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:20];
        _foodInfoLabel.text = @"食物信息";
    }
    return _foodInfoLabel;
}

- (UIImageView *)foodImg{
    if (_foodImg == nil) {
        _foodImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera"]];
        //设置填充模式
        _foodImg.contentMode = UIViewContentModeScaleAspectFill;
        _foodImg.clipsToBounds = YES;
        //设置圆形
        _foodImg.layer.cornerRadius=15;
        _foodImg.userInteractionEnabled = YES; //允许用户交互
        UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDo:)];
        tapA.numberOfTapsRequired = 1;// 连续点击次数
        tapA.numberOfTouchesRequired = 1;// 手指数量
        [_foodImg addGestureRecognizer:tapA];
    }
    return _foodImg;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel createLabelWithColor:[UIColor blueColor] fontSize:14];
        _nameLabel.text = @"名称:";
    }
    return _nameLabel;
}

- (UILabel *)typeLabel{
    if (_typeLabel == nil) {
        _typeLabel = [UILabel createLabelWithColor:[UIColor blueColor] fontSize:14];
        _typeLabel.text = @"类型:";
    }
    return _typeLabel;
}

- (UITextField *)nameTextField{
    if (_nameTextField == nil) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.layer.cornerRadius = 3;
        _nameTextField.layer.borderColor= [UIColor grayColor].CGColor;
        _nameTextField.layer.borderWidth= 0.8f;
    }
    return _nameTextField;
}

- (UITextField *)typeTextField{
    if (_typeTextField == nil) {
        _typeTextField = [[UITextField alloc]init];
        _typeTextField.layer.cornerRadius = 3;
        _typeTextField.layer.borderColor= [UIColor grayColor].CGColor;
        _typeTextField.layer.borderWidth= 0.8f;
    }
    return _typeTextField;
}

- (UIButton *)dayFromBtn{
    if (_dayFromBtn == nil) {
        _dayFromBtn = [[UIButton alloc]init];
        [_dayFromBtn setTitle:@"选择生产日期" forState:UIControlStateNormal];
        _dayFromBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_dayFromBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _dayFromBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_dayFromBtn addTarget:self action:@selector(chooseDayFrom:) forControlEvents:UIControlEventTouchUpInside];
//        [_dayFromBtn setBackgroundColor:[UIColor grayColor]];
    }
    return _dayFromBtn;
}
//生产日期选择器
- (void)chooseDayFrom:(id)sender{
    [ActionSheetDatePicker showPickerWithTitle:@"选择生产时间"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:[NSDate date]
                                   minimumDate:nil
                                   maximumDate:[NSDate dateWithTimeIntervalSinceNow:30 * 24 * 3600]
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         NSDateFormatter *dayFrom = [[NSDateFormatter alloc] init];
                                         [dayFrom setDateFormat:@"yyyy-MM-dd"];
                                        NSString *dateString = [dayFrom stringFromDate:(NSDate*)selectedDate];
                                         DLog(@"%@",dateString);
                                         [_dayFromBtn setTitle:dateString forState:UIControlStateNormal];
                                         
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         DLog(@"cancel");
                                         
                                     } origin:self.view];
}

- (UIButton *)dayToBtn{
    if (_dayToBtn == nil) {
        _dayToBtn = [[UIButton alloc]init];
        [_dayToBtn setTitle:@"选择保质日期" forState:UIControlStateNormal];
        _dayToBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_dayToBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _dayToBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_dayToBtn addTarget:self action:@selector(chooseDayTo:) forControlEvents:UIControlEventTouchUpInside];
        //        [_dayFromBtn setBackgroundColor:[UIColor grayColor]];
    }
    return _dayToBtn;
}

//保质日期选择器
- (void)chooseDayTo:(id)sender{
    
    [ActionSheetDatePicker showPickerWithTitle:@"选择生产时间"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:[NSDate date]
                                   minimumDate:nil
                                   maximumDate:nil
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         NSDateFormatter *dayFrom = [[NSDateFormatter alloc] init];
                                         [dayFrom setDateFormat:@"yyyy-MM-dd"];
                                         NSString *dateString = [dayFrom stringFromDate:(NSDate*)selectedDate];
                                         DLog(@"%@",dateString);
                                         [_dayToBtn setTitle:dateString forState:UIControlStateNormal];
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         DLog(@"cancel");
                                     } origin:self.view];
}

- (UILabel *)dayFromLabel{
    if (_dayFromLabel == nil) {
        _dayFromLabel = [UILabel createLabelWithColor:[UIColor blueColor] fontSize:14];
        _dayFromLabel.text = @"生产日期:";
//        _dayFromLabel.backgroundColor = [UIColor grayColor];
        _dayFromLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dayFromLabel;
}

- (UILabel *)dayToLabel{
    if (_dayToLabel == nil) {
        _dayToLabel = [UILabel createLabelWithColor:[UIColor blueColor] fontSize:14];
        _dayToLabel.text = @"保质到期:";
        _dayToLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dayToLabel;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _countLabel.text = @"1";
    }
    return _countLabel;
}


- (void)setUIStepper{
        self.stepper.maximumValue = 100;
        self.stepper.minimumValue = 0;
        //设置每点一次的增减量
        self.stepper.stepValue = 1;
        //设置一直按住是否连续增加
        self.stepper.autorepeat = YES;
        //设置默认值
    if (self.model) {
        self.stepper.value = [self.model.counts intValue];
    }else{
         self.stepper.value = 1;
    }
    
}
- (IBAction)stepperAction:(UIStepper *)sender {
    int value = sender.value;
    self.countLabel.text = [NSString stringWithFormat:@"%d", value];
}



#pragma mark 保存
- (IBAction)backBtnPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveBtnPressed:(id)sender {
    [self.view endEditing:YES];
    //gid为0就是新增，否则就是更新
    int gid = self.model.gid;
    if (!gid) {
        //新增
        if (self.nameTextField.text.length>0) {
            NSString *imgName = [self saveImage:self.foodImg.image];
            BOOL index = [DataBase insertDataWithName:self.nameTextField.text
                                           andImgName:imgName
                                             andCount:self.countLabel.text
                                           andDayFrom:self.dayFromBtn.titleLabel.text
                                             andDayTo:self.dayToBtn.titleLabel.text
                                              andType:self.typeTextField.text];
            if (index) {
                [self showAlertWithModel:1 andStr:@"添加成功"];
            }else{
                [self showAlertWithModel:2 andStr:@"添加失败"];
            }
        }else{
            [self showAlertWithModel:3 andStr:@"食物名字必填"];
        }

    }else{
        //更新
        NSDictionary *dict = @{@"name":self.nameTextField.text,
                               @"type":self.typeTextField.text,
                               @"dayFrom":self.dayFromBtn.titleLabel.text,
                               @"dayTo":self.dayToBtn.titleLabel.text,
                               @"counts":self.countLabel.text,
                               @"gid":@(gid)};
        DataModel *dModel = [DataModel dataWithDict:dict];
        BOOL index = [DataBase updateWithModel:dModel];
        if (index) {
            [self showAlertWithModel:1 andStr:@"更新成功"];
        }else{
            [self showAlertWithModel:2 andStr:@"更新失败"];
        }
    }
    
}

//图片保存到沙盒
- (NSString *)saveImage:(UIImage *)currentImage
{
    //当前时间作为图片名字
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *imgName = [dayFormat stringFromDate:(NSDate*)nowDate];
//    NSString *imgName = [NSString stringWithFormat:@"%@的图片",dateString];
    //保存到沙盒
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
    NSString *imagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgName];
    [imageData writeToFile:imagePath atomically:NO];
    return imgName;
}

- (void)showAlertWithModel:(int)model andStr:(NSString *)str{
    HHAlertView *alertview = [[HHAlertView alloc] initWithTitle:str detailText:self.nameTextField.text cancelButtonTitle:nil otherButtonTitles:@[@"确定"]];
    //改变提示样式
    switch (model) {
        case 1:[alertview setMode:HHAlertViewModeSuccess];break;
        case 2:[alertview setMode:HHAlertViewModeError];break;
        case 3:[alertview setMode:HHAlertViewModeWarning];break;
        default:break;
    }
    
    [alertview setEnterMode:HHAlertEnterModeFadeIn];
    [alertview setLeaveMode:HHAlertLeaveModeFadeOut];
    [alertview showWithBlock:^(NSInteger index) {
    }];
    
}


#pragma mark - 手势处理（拍照或者从相册中选取的照片）
- (void)tapDo:(UITapGestureRecognizer *)g
{
    DLog(@"点击图片");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //选择相册
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickController = [[UIImagePickerController alloc]init];
        imagePickController.delegate = self;
        imagePickController.allowsEditing = YES;
        imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickController animated:YES completion:^{
        
        }];
    }];
    //选择拍照
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        UIImagePickerController *imagePickController = [[UIImagePickerController alloc]init];
        //判断是否有相机可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickController.delegate = self;
            imagePickController.allowsEditing = YES;
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickController animated:YES completion:^{
                
            }];
        }
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//拍照或者从相册中选取的照片显示到imageView上
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
    self.foodImg.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dealloc {

}

@end
