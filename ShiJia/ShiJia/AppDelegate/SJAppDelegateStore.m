//
//  SJAppDelegateStore.m
//  ShiJia
//
//  Created by yy on 16/6/16.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJAppDelegateStore.h"
#import "ReactiveCocoa.h"
#import "NSObject+RACKVOWrapper.h"
#import <objc/runtime.h>

@interface SJAppDelegateStore ()

@property(nonatomic,strong)NSMutableArray *bindedDelegates;

@end

@implementation SJAppDelegateStore
static SJAppDelegateStore *SINGLETON_SJAppDelegateStore = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

- (void)dealloc
{
    _bindedDelegates = nil;
}

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON_SJAppDelegateStore = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON_SJAppDelegateStore;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)Zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)Zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[SJAppDelegateStore alloc] init];
}

- (id)mutableCopy
{
    return [[SJAppDelegateStore alloc] init];
}

- (id) init
{
    if(SINGLETON_SJAppDelegateStore){
        return SINGLETON_SJAppDelegateStore;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

- (NSMutableArray *)bindedDelegates
{
    if (!_bindedDelegates) {
        _bindedDelegates = [NSMutableArray arrayWithCapacity:20];
    }
    return _bindedDelegates;
}

#pragma mark - mutilple delegates

- (void)bind:(id<SJAppDelegateStoreDelegate>)obj
{
    if(!obj){
        return;
    }
    if (![self.bindedDelegates containsObject:obj]) {
        [self.bindedDelegates addObject:obj];
    }
}

- (void)unbind:(id<SJAppDelegateStoreDelegate>)obj
{
    if(!obj){
        return;
    }
    if ([self.bindedDelegates containsObject:obj]) {
        [self.bindedDelegates removeObject:obj];
    }
}

#pragma mark - listen UIApplication notification

- (void)listenApplicationStatus:(NSObject *)delegate
{
    [self listenUIApplicationNotification];
    [self listenUIApplicationDelegate:delegate];
}

- (void)listenUIApplicationNotification
{
    
    __weak __typeof(self)weakSelf = self;
    //background / forgeground
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationDidEnterBackgroundNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationDidEnterBackground)]) {
                [obj applicationDidEnterBackground];
            }
            i++;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationWillEnterForegroundNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationWillEnterForeground)]) {
                [obj applicationWillEnterForeground];
            }
            i++;
        }
    }];
    
    //active / resign active
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationDidBecomeActiveNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationDidBecomeActive)]) {
                [obj applicationDidBecomeActive];
            }
            i++;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationWillResignActiveNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationWillResignActive)]) {
                [obj applicationWillResignActive];
            }
            i++;
        }
    }];
    
    
    //others
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillTerminateNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationWillTerminateNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationWillTerminate)]) {
                [obj applicationWillTerminate];
            }
            i++;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationDidReceiveMemoryWarningNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationDidReceiveMemoryWarning)]) {
                [obj applicationDidReceiveMemoryWarning];
            }
            i++;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationDidChangeStatusBarOrientationNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationDidChangeStatusBarOrientation)]) {
                [obj applicationDidChangeStatusBarOrientation];
            }
            i++;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillChangeStatusBarOrientationNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationWillChangeStatusBarOrientationNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationWillChangeStatusBarOrientation)]) {
                [obj applicationWillChangeStatusBarOrientation];
            }
            i++;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationBackgroundRefreshStatusDidChangeNotification object:nil]subscribeNext:^(id x) {
        DDLogInfo(@"UIApplicationBackgroundRefreshStatusDidChangeNotification");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger i = 0;
        while (i < [strongSelf.bindedDelegates count]) {
            id obj = [strongSelf.bindedDelegates objectAtIndex:i];
            if ([obj respondsToSelector:@selector(applicationBackgroundRefreshStatusDidChange)]) {
                [obj applicationBackgroundRefreshStatusDidChange];
            }
            i++;
        }
    }];
    
    
}


#pragma mark - listen UIApplicationDelegate

- (void)listenUIApplicationDelegate:(NSObject *)delegate
{
    //push
    [[self rac_registeredForRemoteNotifications:delegate]subscribeNext:^(id x) {
        DDLogInfo(@"%@",x);
    } error:^(NSError *error) {
        DDLogInfo(@"%@",error.localizedDescription);
    } completed:^{
        
    }];
    //others
}


- (RACSignal *)rac_registeredForRemoteNotifications:(NSObject *)delegate
{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    
    RACSignal *didRegisterForRemoteNotification = [[delegate rac_signalForSelector: @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:) fromProtocol: @protocol(UIApplicationDelegate)] map: ^(RACTuple *tuple) {
        return tuple.second;
    }];
    
    RACSignal *failedToRegister = [[delegate rac_signalForSelector: @selector(application:didFailToRegisterForRemoteNotificationsWithError:) fromProtocol: @protocol(UIApplicationDelegate)] flattenMap: ^(RACTuple *tuple) {
        return [RACSignal error: tuple.second];
    }];
    
    signal = [RACSignal merge:@[didRegisterForRemoteNotification, failedToRegister]];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}



#pragma mark -  custom methods for UIApplicationDelegate
/**
 * internal or extrnal jump,except push notification
 *
 *  @param application
 *  @param url
 *  @param sourceApplication
 *  @param annotation
 *
 *  @return
 */
- (BOOL)application_AppDelegateStore:(UIApplication *)application
                                openURL:(NSURL *)url
                      sourceApplication:(NSString *)sourceApplication
                             annotation:(id)annotation
{
    
    NSInteger i = 0;
    while (i < [self.bindedDelegates count]) {
        id obj = [self.bindedDelegates objectAtIndex:i];
        if ([obj respondsToSelector:@selector(application_delegate:openURL:sourceApplication:annotation:)]) {
            [obj application_delegate:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }
        i++;
    }
    return YES;
}

/**
 *  receive remote notification
 *
 *  @param application
 *  @param userInfo
 */
- (void)application_AppDelegateStore:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSInteger i = 0;
    while (i < [self.bindedDelegates count]) {
        id obj = [self.bindedDelegates objectAtIndex:i];
        if ([obj respondsToSelector:@selector(application_delegate:didReceiveRemoteNotification:)]) {
            [obj application_delegate:application didReceiveRemoteNotification:userInfo];
        }
        i++;
    }
}

/**
 *  receive push token
 *
 *  @param application
 *  @param token
 */
- (void)application_AppDelegateStore:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    NSInteger i = 0;
    while (i < [self.bindedDelegates count]) {
        id obj = [self.bindedDelegates objectAtIndex:i];
        if ([obj respondsToSelector:@selector(application_delegate:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [obj application_delegate:application didRegisterForRemoteNotificationsWithDeviceToken:token];
        }
        i++;
    }
}


@end
