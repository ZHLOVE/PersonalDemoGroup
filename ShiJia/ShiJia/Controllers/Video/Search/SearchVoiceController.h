//
//  SearchVoiceController.h
//  HiTV
//
//  Created by jzb on 15/7/30.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//


typedef void (^SpeechResultBlock) (NSString *result);

@interface SearchVoiceController : BaseViewController

- (id)initWithSpeechResult:(SpeechResultBlock)speechResult;

@end
