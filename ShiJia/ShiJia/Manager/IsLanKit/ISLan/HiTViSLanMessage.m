//
//  HiTViSLanMessage.m
//  HiTV
//
//  Created by lanbo zhang on 1/13/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "HiTViSLanMessage.h"

@interface HiTViSLanMessage ()

@property (nonatomic) uint32_t start;
@property (nonatomic) uint32_t version;
@property (nonatomic) uint32_t crc;
@property (nonatomic) uint32_t number;
@property (nonatomic, strong) NSString* src;
@property (nonatomic, strong) NSString* dest;

@property (nonatomic, strong) NSMutableData* body;

@property (nonatomic) uint32_t end;

@property (nonatomic, strong) NSData* tvData;
@property (nonatomic) NSUInteger consumedLength;


@end

const unsigned int MSG_ID[] = {
#define MSGID_DEF(N, I)     I,
#include "HiTViSLanMessageId.h"
#undef MSGID_DEF
};

const char *MSG_NAME[] = {
    #define MSGID_DEF(N, I)     #N,
    #include "HiTViSLanMessageId.h"
    #undef MSGID_DEF
};

@implementation HiTViSLanMessage

+ (NSString *)idToString:(iSLanMessageID)msgId {
    for (int i = 0; i < sizeof(MSG_ID) / sizeof(unsigned int); i ++) {
        if (MSG_ID[i] == msgId) {
            return [NSString stringWithUTF8String:MSG_NAME[i]];
        }
    }
    
    return [NSString stringWithFormat:@"UnknownId: 0x%08lx", (unsigned long)msgId];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.start = 0xABCDEFFF;
        self.version = 0x00000001;
        self.crc = 0;
        self.number = 0;
        self.src = @"com.multiscreen.framework.send.app";
        self.dest = @"com.multiscreen.framework.receiver.app";
        self.end = 0xFFFEDCBA;
        
        self.body = [NSMutableData data];
    }
    return self;
}

- (instancetype)initWithData:(NSData*)data{
    self = [super init];
    
    if (self) {
        self.tvData = data;
        self.consumedLength = 0;
        
        
        self.start = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.version = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);

        self.crc = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);

        self.number = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);

        self.src = [self p_readStringValueFromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t) + self.src.length;

        self.dest = [self p_readStringValueFromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t) + self.dest.length;
        
        self.body = [[self p_readDataFromData:self.tvData withOffset:self.consumedLength] mutableCopy];
        self.consumedLength += sizeof(uint32_t) + self.body.length;
        
        self.end = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.messageID = [self readUInt];
    }
    return self;
}
//add buy jhl 20150831
- (instancetype)initWithDataForListener:(NSData*)data{
    self = [super init];
    
    if (self) {
        self.tvData = data;
        self.consumedLength = 0;
        
        
        self.start = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.version = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.crc = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.number = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.src = [self p_readStringValueFromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t) + self.src.length;
        
        self.dest = [self p_readStringValueFromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t) + self.dest.length;

        self.automatic = [self p_readIntfromData:self.tvData withOffset:self.consumedLength+sizeof(uint32_t)];
        self.consumedLength += sizeof(uint32_t)+sizeof(uint32_t);

        self.body = [[self p_readDataFromData:self.tvData withOffset:self.consumedLength] mutableCopy];

        self.tvAnonymousUid = [[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding];
        
        self.consumedLength += sizeof(uint32_t) + self.body.length;
        
        self.end = [self p_readIntfromData:self.tvData withOffset:self.consumedLength];
        self.consumedLength += sizeof(uint32_t);
        
        self.messageID = [self readUInt];
    }
    return self;
}
//end
- (void)writeByte:(uint8_t)byteValue{
    [self.body appendBytes:&byteValue length:sizeof(uint8_t)];
}


- (void)writeInt:(uint32_t)intValue{
    [self p_appendInt:intValue toData:self.body];
}


- (void)writeStringValue:(NSString*)stringValue{
    //modify by jianghailiang 20150311
    NSUInteger bytes = [stringValue lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [self writeInt:(uint32_t)bytes];
    //end
    NSData* data = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.body appendData:data];
}

- (NSData*)makeData{
    NSMutableData* data = [NSMutableData data];
    
    [self p_appendInt:self.start toData:data];
    [self p_appendInt:self.version toData:data];
    [self p_appendInt:self.crc toData:data];
    [self p_appendInt:self.number toData:data];
    
    NSData* stringData = [self.src dataUsingEncoding:NSUTF8StringEncoding];
    [self p_appendInt:(int)stringData.length toData:data];
    [data appendData:stringData];
    stringData = [self.dest dataUsingEncoding:NSUTF8StringEncoding];
    [self p_appendInt:(int)stringData.length toData:data];
    [data appendData:stringData];
    
    //[self p_appendUInt:self.messageID toData:data];
    
    [self p_appendInt:(uint32_t)self.body.length toData:data];
    [data appendData:self.body];
    
    [self p_appendInt:self.end toData:data];
    return data;
}
- (uint8_t)readByte{
    uint8_t intValue = *((uint8_t*)((uint8_t*)[self.body bytes]));
    self.body = [[self.body subdataWithRange:NSMakeRange(sizeof(uint8_t), self.body.length - sizeof(uint8_t))] mutableCopy];

    return intValue;
}

- (int32_t)readInt{
    if (self.body.length < sizeof(uint32_t)) {
        return 0;
    }
    uint32_t intValue = [self p_readIntfromData:self.body withOffset:0];
    self.body = [[self.body subdataWithRange:NSMakeRange(sizeof(uint32_t), self.body.length - sizeof(uint32_t))] mutableCopy];
    uint32_t convertedIntValue = CFSwapInt32BigToHost(intValue);
    
    return convertedIntValue;
}

- (uint32_t)readUInt{
    if (self.body.length < sizeof(uint32_t)) {
        return 0;
    }
    uint32_t intValue = [self p_readIntfromData:self.body withOffset:0];
    self.body = [[self.body subdataWithRange:NSMakeRange(sizeof(uint32_t), self.body.length - sizeof(uint32_t))] mutableCopy];
    return intValue;
}

- (NSString*)readStringValue{
    NSData* stringData = [self readData];
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (NSData*)readData{
    uint32_t dataLength = [self readUInt];
    if (dataLength >= 0x01000000) {
        dataLength = CFSwapInt32BigToHost(dataLength);
    }
    
    if (self.body.length < dataLength) {
        return nil;
    }
    NSData* data = [self.body subdataWithRange:NSMakeRange(0, dataLength)];
    self.body = [[self.body subdataWithRange:NSMakeRange(data.length, self.body.length - data.length)] mutableCopy];

    return data;
}

#pragma mark - private
- (void)p_appendUInt:(uint32_t)intValue toData:(NSMutableData*)data{
    [data appendBytes:&intValue length:4];
}

- (void)p_appendInt:(uint32_t)intValue toData:(NSMutableData*)data{
    uint32_t convertedInt = CFSwapInt32HostToBig(intValue);
    [data appendBytes:&convertedInt length:4];
}

- (uint32_t)p_readIntfromData:(NSData*)data withOffset:(NSUInteger)offset{
    uint32_t intValue = *((uint32_t*)((uint8_t*)[data bytes] + offset));
    return CFSwapInt32BigToHost(intValue);
}

- (NSString*)p_readStringValueFromData:(NSData*)data withOffset:(NSUInteger)offset{
    NSData* stringData = [self p_readDataFromData:data withOffset:offset];
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (NSData*)p_readDataFromData:(NSData*)data withOffset:(NSUInteger)offset{
    uint32_t stringLength = [self p_readIntfromData:data withOffset:offset];
    if (stringLength>data.length) {
        return nil;
    }
    return [data subdataWithRange:NSMakeRange(offset + sizeof(uint32_t), stringLength)];
}

@end
