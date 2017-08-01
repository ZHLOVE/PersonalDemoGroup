//
//  HiTViSLanMessage.h
//  HiTV
//
//  Created by lanbo zhang on 1/13/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, iSLanMessageID) {
    #define MSGID_DEF(N, I) N = I,
    #include "HiTViSLanMessageId.h"
    #undef MSGID_DEF
};


@interface HiTViSLanMessage : NSObject

@property (nonatomic) iSLanMessageID messageID;

+ (NSString *) idToString:(iSLanMessageID) msgId;

//from phone
- (instancetype)init;

//from tv
- (instancetype)initWithData:(NSData*)data;
//add buy jhl 20150831
@property (nonatomic,strong) NSString * tvAnonymousUid;
@property (nonatomic) int automatic;

- (instancetype)initWithDataForListener:(NSData*)data;
//end
- (void)writeByte:(uint8_t)byteValue;

- (void)writeInt:(uint32_t)intValue;

- (void)writeStringValue:(NSString*)stringValue;

- (uint8_t)readByte;
- (int32_t)readInt;
- (uint32_t)readUInt;
- (NSString*)readStringValue;


- (NSData*)makeData;

@end
