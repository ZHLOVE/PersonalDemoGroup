//
//  TPIMErrors.h
//  XmppDemo
//
//  Created by yy on 7/2/15.
//  Copyright (c) 2015 yy. All rights reserved.
//

#ifndef __TPIMERRORS__
#define __TPIMERRORS__

static NSString * const TPIMErrorDomain = @"com.ysten.TPIM";

typedef CF_ENUM (int, TPIMErrors){
    
    //authenticate error
    kTPErrorAuthenticationFailure = 1,
    
    //connect error
    kTPErrorConnectFailure = 2,
    kkTPErrorConnectTimeout = 201,
    
    //disconnect error
    kTPErrorDisconnectFailure = 3,
    
    //register error
    kTPErrorRegisterFailure = 4,
    
    //userinfo
    kTPErrorGetUserinfoFailure = 5
    
};

#endif
