//
//  SJPublicChatRoomMainView.m
//  ShiJia
//
//  Created by yy on 16/6/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "SJPublicChatRoomMainView.h"
#import "TPPublicMUCInputView.h"

#import "TPPrivateMUCInputView.h"
#import "SJChatRoomMessageCell.h"
#import "SJChatRoomIncomingMessageCell.h"
#import "SJChatRoomOutgoingMessageCell.h"

#import "SJYueViewController.h"
#import "SJInviteUserViewController.h"

#import "SJPublicChatRoomViewModel.h"
#import "TPIMMessage.h"
#import "TPIMContentModel.h"
#import "XMPPJID.h"
#import "TPMessageRequest.h"

#import "SJChatRoomIncomingMessageCell.h"
#import "SJChatRoomOutgoingMessageCell.h"
#import "SJLoginViewController.h"
#import "SJMUCUserInfoViewController.h"

@interface SJPublicChatRoomMainView ()<ASTableDataSource,ASTableDelegate,TPPublicMUCInputViewDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *onlineNumLabel;
@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, readwrite, strong) TPPublicMUCInputView *inputView;
@property (nonatomic, strong) NSMutableArray *messageList;//消息列表

@property (nonatomic, strong) SJPublicChatRoomViewModel *viewModel;

@end

@implementation SJPublicChatRoomMainView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _messageList = [[NSMutableArray alloc] init];
        
        
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainView];
        
        _onlineNumLabel = [[UILabel alloc] init];
        _onlineNumLabel.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];
        _onlineNumLabel.layer.cornerRadius = 15.0;
        _onlineNumLabel.layer.masksToBounds = YES;
        _onlineNumLabel.font = [UIFont systemFontOfSize:13.0];
        _onlineNumLabel.textColor = [UIColor darkGrayColor];
        _onlineNumLabel.text = @"在线用户0人";
        _onlineNumLabel.textAlignment = NSTextAlignmentCenter;
        [_mainView addSubview:_onlineNumLabel];
        
        // table view
        _tableView = [[ASTableView alloc] initWithFrame: CGRectZero
                                                  style: UITableViewStylePlain
                                      asyncDataFetching: YES];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // SocialAppNode has its own separator
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_mainView addSubview:_tableView];
        
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_mainView addGestureRecognizer:tableViewGesture];
        
        
        //输入view
        _inputView = [[TPPublicMUCInputView alloc] init];
        _inputView.delegate = self;
        [self addSubview:_inputView];
        [RACObserve(_inputView, beyonded) subscribeNext:^(NSNumber *x) {
            
            self.beyonded = x.boolValue;
            
            
        }];
        _viewModel = [[SJPublicChatRoomViewModel alloc] init];
        
        [RACObserve(_viewModel, onlineNum) subscribeNext:^(NSNumber *x) {
            _onlineNumLabel.text = [NSString stringWithFormat:@"在线用户%zd人",[x integerValue]];
        }];
        __weak __typeof(self)weakSelf = self;
        
        [_viewModel setDidReceiveMessage:^(TPIMMessage *message, TPDanmakuData * danmuData) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.messageList addObject:message];
            
            if (strongSelf.messageList.count == 0) {
                return;
            }
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:strongSelf.messageList.count-1 inSection:0];
            [strongSelf.tableView beginUpdates];
            [strongSelf.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationBottom];
            
            [strongSelf.tableView endUpdatesAnimated:NO completion:^(BOOL completed) {
                if (completed) {
                    NSInteger rowcount = [strongSelf.tableView numberOfRowsInSection:0];

                    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:rowcount - 1 inSection:0];
                     if (strongSelf.messageList.count>0) {
                    [strongSelf.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                     }
                }
                
            }];
            
            if (strongSelf.publicRoomDidReceiveDanmuData && danmuData) {
                strongSelf.publicRoomDidReceiveDanmuData(danmuData);
            }
        }];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kTPPublicMUCInputViewHeight);
    
    CGRect rect = [_onlineNumLabel.text boundingRectWithSize:CGSizeMake(FLT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_onlineNumLabel.font,NSFontAttributeName, nil] context:nil];
    
    _onlineNumLabel.frame = CGRectMake((_mainView.frame.size.width - rect.size.width - 10) / 2.0, 10, rect.size.width + 20, 30);
    
    
    CGFloat originy = _onlineNumLabel.frame.origin.y + _onlineNumLabel.frame.size.height;
    _tableView.frame = CGRectMake(0,
                                  originy,
                                  _mainView.frame.size.width,
                                  _mainView.frame.size.height - originy);
    
    _inputView.frame = CGRectMake(0,
                                  self.frame.size.height - kTPPublicMUCInputViewHeight,
                                  self.frame.size.width,
                                  kTPPublicMUCInputViewHeight);
    
}

#pragma mark - ASTableDataSource & ASTableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageList.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPIMMessage *msg = [self.messageList objectAtIndex:indexPath.row];
    
    SJChatRoomMessageCell *msgCell;
    
    if (![msg.fromName isEqualToString:[HiTVGlobals sharedInstance].nickName]) {
        
        SJChatRoomIncomingMessageCell *cell = [[SJChatRoomIncomingMessageCell alloc] init];
        
        //好友消息
        if ([msg isKindOfClass:[TPIMContentMessage class]]) {
            
            //文字消息
            
            [cell showMessage:(TPIMContentMessage *)msg];
        }
        else if ([msg isKindOfClass:[TPIMVoiceMessage class]]){
            
            //语音消息
            TPIMVoiceMessage *voiceMsg = (TPIMVoiceMessage *)msg;
            
            [cell showRecordMessage:voiceMsg];
        }
        msgCell = cell;
        //return cell;
        
    }
    else{
        
        SJChatRoomOutgoingMessageCell *cell = [[SJChatRoomOutgoingMessageCell alloc] init];
        
        //登录用户消息
        if ([msg isKindOfClass:[TPIMContentMessage class]]) {
            //文字消息
            
            [cell showMessage:(TPIMContentMessage *)msg];
        }
        else if ([msg isKindOfClass:[TPIMVoiceMessage class]]){
            
            //语音消息
            TPIMVoiceMessage *voiceMsg = (TPIMVoiceMessage *)msg;
            
            [cell showRecordMessage:voiceMsg];
        }
        msgCell = cell;
        //return cell;
    }
    
    [msgCell setShowUserInfoBlock:^(SJChatRoomMessageCell *sender) {
        
        NSInteger row = [tableView indexPathForNode:sender].row;
        TPIMMessage *msgData = [self.messageList objectAtIndex:row];
        if ([msgData.uid.description isEqualToString:[HiTVGlobals sharedInstance].uid.description]) {
            return;
        }
        UserEntity *userData = [[UserEntity alloc] init];
        userData.uid = msgData.uid;
        userData.phoneNo = msgData.fromphone;
        userData.faceImg = msgData.fromHeadUrl;
        userData.nickName = msgData.fromName;
        
        SJMUCUserInfoViewController *userInfoVC = [[SJMUCUserInfoViewController alloc] init];
        userInfoVC.userEntity = userData;
        [self.activeController.navigationController pushViewController:userInfoVC animated:YES];
        
    }];
    
    [msgCell setAtUserNameBlock:^(SJChatRoomMessageCell *sender) {
        
        NSInteger row = [tableView indexPathForNode:sender].row;
        TPIMMessage *msgData = [self.messageList objectAtIndex:row];
        if ([msgData.uid.description isEqualToString:[HiTVGlobals sharedInstance].uid.description]) {
            return;
        }
        self.inputView.textview.text = [self.inputView.textview.text stringByAppendingString:[NSString stringWithFormat:@"@%@ ",msgData.fromName]];
        [self.inputView.textview becomeFirstResponder];
        
    }];
    
    [msgCell setVoiceMessageWillStartPlayingBlock:^{
        if (self.voiceMessageWillStartPlay) {
            self.voiceMessageWillStartPlay();
        }
    }];
    
    [msgCell setVoiceMessageDidFinishPlayingBlock:^{
        if (self.voiceMessageDidFinishPlaying) {
            self.voiceMessageDidFinishPlaying();
        }
    }];
    
    return msgCell;
}

#pragma mark - TPMUCInputViewDelegate
- (void)publicRoomSendMessage:(NSString *)msg
{
    DDLogInfo(@"%@",msg);
    if (![HiTVGlobals sharedInstance].isLogin && self.activeController) {
        
        SJLoginViewController *loginVC = [[SJLoginViewController alloc] init];
        [self.activeController presentViewController:loginVC animated:YES completion:nil];
        return;
        
    }
    
    [_viewModel publicRoomSendMessage:msg];
    [UMengManager event:@"U_Square"];
    
}

- (void)publicRoomSendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat)recordDuration
{
    if (![HiTVGlobals sharedInstance].isLogin && self.activeController) {
        
        SJLoginViewController *loginVC = [[SJLoginViewController alloc] init];
        [self.activeController presentViewController:loginVC animated:YES completion:nil];
        return;
        
    }
    [_viewModel publicRoomSendRecordData:recordData recordString:recordString recordDuration:recordDuration];
}

#pragma mark - Public
- (void)leaveChatRoom
{
    [self.messageList removeAllObjects];
    [self.tableView reloadData];
    [_viewModel leaveRoom];
}

#pragma mark - Event
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    [_inputView resignFirstResponder];
}

#pragma mark -  Setter
- (void)setChannelId:(NSString *)channelId
{
    _channelId = channelId;
    
    if (channelId.length > 0) {
        
        [_viewModel getChanelRoomWithChanelId:channelId success:^(NSString * roomid) {
            
            
        } failed:^(NSString *error) {
            
        }];
    }
    
}

@end
#pragma clang diagnostic pop
