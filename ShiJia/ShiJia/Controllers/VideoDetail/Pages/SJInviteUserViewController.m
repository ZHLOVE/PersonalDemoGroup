//
//  SJInvertUserViewController.m
//  ShiJia
//
//  Created by yy on 16/3/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJInviteUserViewController.h"
#import "SJContactListView.h"
#import "SJGetUserDataAPI.h"
#import "TPIMUser.h"

@interface SJInviteUserViewController ()


@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) SJContactListView *contactView;
@property (nonatomic, strong) TRTopNavgationView *naviView;

@property (strong, nonatomic)  UIView *defaultView;//缺省页
@property (nonatomic, strong) UITextField *textFake;
@property (nonatomic, assign) BOOL hasKeyboard;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation SJInviteUserViewController

#pragma mark - Lifecycle

-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}

- (instancetype)init
{
    self = [super init];

    if (self) {

        _contactView = [[SJContactListView alloc] initWithUsers:nil];
        _contactView.bottomButtonTitle = @"发送邀请";
        _textFake = [UITextField new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kColorLightGrayBackground;


    [self initNavigationView];

    //好友列表view
    [SJGetUserDataAPI getFriendListWithSuccess:^(NSArray<UserEntity *> *responseObject) {
        NSArray *list = [NSArray arrayWithArray:responseObject];

        NSMutableArray *array = [NSMutableArray arrayWithArray:list];

        for (UserEntity *entity in list) {

            for (TPIMUser *user in _disabledUserList) {
                if (user.jid.length >0 && entity.jid.length > 0 ) {
                    if ([user.jid rangeOfString:entity.jid].location != NSNotFound || [entity.jid rangeOfString:user.jid].location != NSNotFound) {
                        [array removeObject:entity];
                    }

                }
            }
        }
        _contactView.userList = [NSArray arrayWithArray:array];
        if (_contactView.userList.count == 0) {
            self.defaultView.hidden = NO;
            _contactView.hidden = YES;
        }
        else{
            self.defaultView.hidden = YES;
            _contactView.hidden = NO;
        }

    } failed:^(NSString *error) {

    }];

    // 发送邀请消息
    __weak __typeof(self)weakSelf = self;
    [_contactView setBottomButtonClickBlock:^(NSArray *list) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (strongSelf.didSelectedUserList) {

            strongSelf.didSelectedUserList(list);

        }
        [strongSelf.navigationController popViewControllerAnimated:YES];

    }];


    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWasShown:)

                                                 name:UIKeyboardWillShowNotification object:nil];

    //注册键盘消失的通知

    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWillBeHidden:)

                                                 name:UIKeyboardWillHideNotification object:nil];


    [self.view addSubview:_contactView];
}

- (void)keyboardWasShown:(NSNotification*)aNotification{

    _hasKeyboard = YES;
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    _hasKeyboard = NO;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    _contactView.frame = CGRectMake(0,
                                    _naviView.frame.size.height,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height - _naviView.frame.size.height);
}
-(UIView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
        _defaultView.backgroundColor = [UIColor clearColor];

        UIImageView *zwddImg = [[UIImageView alloc]initWithFrame:CGRectMake(55, 0, 90, 90)];
        zwddImg.image = [UIImage imageNamed:@"img_none_friend"];
        [_defaultView addSubview:zwddImg];


        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 200, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"您还没有好友先去添加几个吧～";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab];

        _defaultView.center = CGPointMake(W/2, H/2-100);

        [self.view addSubview:_defaultView];
    }

    return _defaultView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kNavgationBarColor;

    // back button
    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"white_back_btn"]
                                      highlightImg:[UIImage imageNamed:@"white_back_btn"]
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    __weak __typeof(self)weakSelf = self;
    [[backBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_naviView setLeftView:backBt];

    // title
    UILabel* lbl = [UIHelper createTitleLabel:@"选择好友"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];

    UIButton* sureBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:nil
                                      highlightImg:nil
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    [sureBt setTitle:@"确定" forState:UIControlStateNormal];
    sureBt.enabled = NO;
    sureBt.titleLabel.textAlignment = 2;
    sureBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    @weakify(self)


    [[sureBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (_hasKeyboard) {
                [self.contactView.fakeText resignFirstResponder];
        }else{

            if (self.didSelectedUserList) {

                self.didSelectedUserList(self.selectedArray.copy);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];

    [self.contactView.selectNumberSubject subscribeNext:^(id x) {

        NSArray *array = (NSArray *)x;
        self.selectedArray = [array mutableCopy];
        NSString *string = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)array.count];
        [sureBt setTitle:array.count>0?string:@"确定" forState:UIControlStateNormal];
        [sureBt setTitleColor:array.count>0?kColorBlueTheme:[UIColor grayColor] forState:UIControlStateNormal];
        sureBt.enabled = array.count>0?YES:NO;
        
    }];
    
    sureBt.frame = CGRectMake(SCREEN_WIDTH-80, 2, 80, 44);
    [_naviView setRightView:sureBt];
    
    
}


@end
