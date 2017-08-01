//
//  SJChatRoomMainView.m
//  ShiJia
//
//  Created by yy on 16/4/1.
//  Copyright © 2016年 yy. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "SJPrivateChatRoomMainView.h"

#import "TPPrivateMUCInputView.h"
#import "SJChatRoomMessageCell.h"
#import "SJChatRoomIncomingMessageCell.h"
#import "SJChatRoomOutgoingMessageCell.h"
#import "SJChatRoomTipCell.h"

#import "SJYueViewController.h"
#import "SJInviteUserViewController.h"

#import "TPXmppRoomManager.h"
#import "SJChatRoomViewModel.h"
#import "TPIMMessage.h"
#import "TPIMContentModel.h"
#import "XMPPJID.h"
#import "TPMessageRequest.h"
#import "TPDanmakuData.h"

#import "SJLoginViewController.h"
#import "SJMUCUserInfoViewController.h"

@interface SJPrivateChatRoomMainView ()<ASTableDataSource,ASTableDelegate,TPPrivateMUCInputViewDelegate>
{
    NSArray *msgArray;
    CGFloat emptyWidth;
}

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, readwrite, strong) TPPrivateMUCInputView *inputView;
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, retain) NSMutableArray *messageList;//消息列表

@end

@implementation SJPrivateChatRoomMainView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
   
    if (self) {
        _messageList = [[NSMutableArray alloc] init];
        
        // empty view
        [self setupEmptyView];
        [self addSubview:_emptyView];
        
        // table view
        _tableView = [[ASTableView alloc] initWithFrame: CGRectZero
                                                  style: UITableViewStylePlain
                                      asyncDataFetching: YES];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
       
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tableViewGesture];

        //输入view
        _inputView = [[TPPrivateMUCInputView alloc] init];
        _inputView.delegate = self;
        [_inputView.inviteSignal subscribeNext:^(id x) {
            [self.inputView resignFirstResponder];
            self.activeController.hidesBottomBarWhenPushed = YES;
            SJYueViewController *yueVC = [[SJYueViewController alloc] init];
            yueVC.list = [NSArray arrayWithArray:[TPXmppRoomManager defaultManager].roomMemberList];
            [self.activeController.navigationController pushViewController:yueVC animated:YES];
            
        }];
        [RACObserve(_inputView, beyonded) subscribeNext:^(NSNumber *x) {
            
            self.beyonded = x.boolValue;
            
        }];
        
        [self addSubview:_inputView];
        
        _inputView.userCount = [TPXmppRoomManager defaultManager].roomMemberList.count;
        
        [[TPXmppRoomManager defaultManager] setDidFinishInvitation:^{
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
            self.inputView.hidden = NO;
        }];
        
        
        [[TPXmppRoomManager defaultManager] setDidReceiveMessage:^(TPIMMessage *message, TPDanmakuData *danmuData) {
            __weak __typeof(self)weakSelf = self;
            
            [self.messageList addObject:message];
            
            if (self.messageList.count == 0) {
                return;
            }
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationBottom];
            
            [self.tableView endUpdatesAnimated:NO completion:^(BOOL completed) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (completed) {
                    NSInteger rowcount = [strongSelf.tableView numberOfRowsInSection:0];
                    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:rowcount - 1 inSection:0];
                    if (strongSelf.messageList.count>0) {
                    [strongSelf.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }
            }];
            
            if (self.privateRoomDidReceiveDanmuData && danmuData) {
                self.privateRoomDidReceiveDanmuData(danmuData);
            }
            
        }];
        
        [[TPXmppRoomManager defaultManager] setDidUpdateUserList:^(NSArray *list){
            
            _inputView.userCount = list.count;
            if (!self.emptyView.hidden) {
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                self.inputView.hidden = NO;
            }
            
        }];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _emptyView.frame = CGRectMake((self.frame.size.width - emptyWidth) / 2.0, 10, emptyWidth, 40);
    
    _tableView.frame = CGRectMake(0,
                                  0,
                                  self.frame.size.width,
                                  self.frame.size.height - kTPPrivateMUCInputViewHeight);
    
    _inputView.frame = CGRectMake(0,
                                  self.frame.size.height - kTPPrivateMUCInputViewHeight,
                                  self.frame.size.width,
                                  kTPPrivateMUCInputViewHeight);
    if ([TPXmppRoomManager defaultManager].roomMemberList.count <= 0) {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
        _inputView.hidden = YES;
    }
    else{
        _emptyView.hidden = YES;
        _tableView.hidden = NO;
        _inputView.hidden = NO;
        _inputView.hidden = NO;
    }
    
}

- (void)setupEmptyView
{
    _emptyView = [[UIView alloc] init];
    _emptyView.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];
    _emptyView.layer.cornerRadius = 20.0;
    _emptyView.layer.masksToBounds = YES;
    

    NSString *string = @"聊天室有点凄凉,邀请好友一起看";
    
    UILabel *label1 = [[UILabel alloc] init];
    //label1.frame = CGRectMake(10, 10, 104, 20);
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.textColor = [UIColor lightGrayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    //label1.text = @"聊天室有点凄凉，";
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:14.0] } documentAttributes:nil error:nil];
    
    [label1 setAttributedText:attrStr];
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label1.font} context:nil];
    rect.size.width += 25.0;
    label1.frame = CGRectMake(10, 12, rect.size.width, rect.size.height);
    label1.textAlignment = NSTextAlignmentCenter;
    [_emptyView addSubview:label1];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = label1.frame;
    [button addTarget:self action:@selector(inviteUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_emptyView addSubview:button];
    emptyWidth = rect.size.width + 10 * 2;
    
    
}

#pragma mark - ASTableDataSource & ASTableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.messageList objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        
        SJChatRoomTipCell *cell = [[SJChatRoomTipCell alloc] init];
        cell.preferredFrameSize = CGSizeMake(tableView.frame.size.width, 59);
        cell.text = [self.messageList objectAtIndex:indexPath.row];
        return cell;
        
    }
    else{
        
        SJChatRoomMessageCell *msgCell;
        TPIMMessage *msg = [self.messageList objectAtIndex:indexPath.row];
        
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
    
}

#pragma mark - TPMUCInputViewDelegate
- (void)privateRoomSendMessage:(NSString *)msg
{
    DDLogInfo(@"%@",msg);
    if (![HiTVGlobals sharedInstance].isLogin && self.activeController) {
        
        SJLoginViewController *loginVC = [[SJLoginViewController alloc] init];
        [self.activeController presentViewController:loginVC animated:YES completion:nil];
        return;
        
    }
    
    if (msg.length > 20) {
        [OMGToast showWithText:@"文字超过上限，限20字以内"];
        return;
    }
    
    [[TPXmppRoomManager defaultManager] sendMessage:msg];
    [UMengManager event:@"U_Chat"];


}

- (void)privateRoomSendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat)recordDuration
{
    if (![HiTVGlobals sharedInstance].isLogin && self.activeController) {
        
        SJLoginViewController *loginVC = [[SJLoginViewController alloc] init];
        [self.activeController presentViewController:loginVC animated:YES completion:nil];
        return;
        
    }
    [[TPXmppRoomManager defaultManager] sendRecordData:recordData recordString:recordString recordDuration:recordDuration];
}

#pragma mark - Event
- (void)inviteUserButtonClicked:(id)sender
{
    self.activeController.hidesBottomBarWhenPushed = YES;
    
    SJInviteUserViewController *inviteVC = [[SJInviteUserViewController alloc] init];
    inviteVC.disabledUserList = [NSArray arrayWithArray:[TPXmppRoomManager defaultManager].roomMemberList];
    
    [inviteVC setDidSelectedUserList:^(NSArray *list) {
        
        [TPXmppRoomManager defaultManager].invitedUserList = [NSArray arrayWithArray:list];

        if ([TPXmppRoomManager defaultManager].roomMemberList.count == 0) {
            // 创建房间并邀请好友
            [[TPXmppRoomManager defaultManager] sendInvitationMessageAndCreateRoom];
        }
        else{
            //房间已创建，仅邀请好友
            [[TPXmppRoomManager defaultManager] sendInvitationMessageWithRoomId:[TPXmppRoomManager defaultManager].roomId];
        }
        
    }];
    [self.activeController.navigationController pushViewController:inviteVC animated:YES];
}

- (void)leaveChatRoom
{
    [[TPXmppRoomManager defaultManager] leaveRoom];
}

- (void)refreshData
{
    _inputView.userCount = [TPXmppRoomManager defaultManager].roomMemberList.count;
    [self setNeedsLayout];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    [_inputView resignFirstResponder];
}

#pragma mark - UITouch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_inputView.textview isExclusiveTouch]) {
        [_inputView resignFirstResponder];
    }
}


@end

#pragma clang diagnostic pop
