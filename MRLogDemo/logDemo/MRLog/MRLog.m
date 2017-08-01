//
//  MRLog.m
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "MRLog.h"
#import "MRDataBase.h"
#import "NSString+Conversion.h"
#import "LogTable.h"
#import "BaseNetwork.h"

#define logHost @"http://203.195.197.16:8080"
#define pollSec 60 //轮询时间单位s

@interface MRLog()

@property(nonatomic,strong) MRDataBase *mrObject;

@property (nonatomic, strong) dispatch_source_t timerPolling;



@end

@implementation MRLog


+ (instancetype)sharedMRLog{
    static MRLog *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[MRLog alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startPollingRound];
    }
    return self;
}

- (MRDataBase *)mrObject{
    if (_mrObject == nil) {
        _mrObject = [MRDataBase sharedMRDataBase];
    }
    return _mrObject;
}

/**
 app启动Log处理
 */
- (void)appStartHandleLog{
    [self clearMRLogAccordToSendState];
    [self handleLogTable];
    [self reportLog];

}

/**
 日志记录
 */
- (void)logEventWithEventModel:(EventModel *)props{
    LogTable *log = [[LogTable alloc]init];
    LogPublicInfo *lp = [[LogPublicInfo alloc]init];
    lp.event_id = props.event_id;
    lp.props = [props.mj_JSONString lowercaseString];
    log.logPub = lp;
    NSString *tempStr = [lp.mj_JSONString replaceJSONStrToStr:lp.mj_JSONString];
    NSString *logText = [NSString stringWithFormat:@"%@/1/400/log/%@",log.curtime,tempStr];
    log.logText = logText;
    [self.mrObject insertDataToLogTable:log];
}


/**
 拿到发送表里要发送的数据
 */
- (NSArray *)getSendArr{
    return [self.mrObject getDataFromSendTableToSend];
}


/**
 上报日志失败
 */
- (void)reportLogFail:(NSString *)seqid{
    [self.mrObject failedUpdateSendTable:seqid];
}

/**
 上报日志成功
 */
- (void)reportLogSuccess:(NSString *)seqid{
    [self.mrObject successUpdateSendTableState:seqid];
    [self clearSuccessLog];
}


/**
 上报成功后清理发送成功的数据
 */
- (void)clearSuccessLog{
    [self.mrObject searchSendTableAndClearSuccessData];
}

/**
 清理日志
 a)清理发送表中发送成功的数据
 b)处理发送状态0的数据
 */
- (void)clearMRLogAccordToSendState{
    [self.mrObject searchSendTableAndClearSuccessData];
    [self.mrObject handleLogAccordToSendState];
}

/**
 选择日志表state 0 或 999的分页插入发送表
 */
- (void)handleLogTable{
    [self.mrObject insertSendTableAccordToLogState];
}

/**
 上报日志
 */
- (void)reportLog{
    [self postTheLogOnSendState];
}


/**
 立即查日志表,整理后发送
 */
- (void)reportLogRightNow{
    [self handleLogTable];
    [self postTheLogOnSendState];
}


/**
 POST数据
 */
- (void)postTheLogOnSendState{
    __weak typeof(self) weakSelf = self;
    NSArray *sendArr = [self getSendArr];
    for (SendTable *s in sendArr) {
        NSDictionary *sendDict = s.mj_keyValues;
        NSLog(@"上报日志seqid====>\n%@",sendDict[@"seqid"]);
        [BaseNetwork postRequestHTTPSerializerForHost:logHost forParam:@"/logger/m/logup.action" forParameters:sendDict completion:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [weakSelf reportLogSuccess:s.seqid];
        } failure:^(NSString *error) {
            NSLog(@"%@",error);
            [weakSelf reportLogFail:s.seqid];
        }];
    }
}


#pragma mark -轮询
/**
 轮询
 */
- (void)startPollingRound{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timerPolling = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pollSec * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(pollSec * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timerPolling, start, interval, 0);
    dispatch_source_set_event_handler(self.timerPolling, ^{
        NSLog(@"轮询发送表");
        NSArray *sendArr = [weakSelf.mrObject getDataFromSendTableToSend];
        if (sendArr.count) {
            [weakSelf reportLog];
        }else{
            [weakSelf handleLogTable];
            [weakSelf reportLog];
        }
    });
    dispatch_resume(self.timerPolling);
}


/**
 取消轮询
 */
- (void)cancelPolling{
    dispatch_cancel(self.timerPolling);
}



#pragma mark -其他














@end
