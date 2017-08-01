//
//  SJMyPhotoViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMyPhotoViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SJMyPhotoViewModel ()

@property (nonatomic, strong) NSMutableArray *localPhotoArray;

@end

@implementation SJMyPhotoViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoModelSubject = [RACSubject subject];
    }
    return self;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}
//-(NSMutableArray *)modelArray{
//    if (!_modelArray) {
//        _modelArray = [NSMutableArray new];
//    }
//    return _modelArray;
//}
-(void)getGroup{
    WEAKSELF
        ALAssetsLibraryAccessFailureBlock failureblock =^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);

            [weakSelf.photoModelSubject sendError:myerror];
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            if (group!=nil){
                if ([[[group valueForProperty:ALAssetsGroupPropertyType] description] isEqualToString:@"16"]) {
                    UIImage *image =[UIImage imageWithCGImage:group.posterImage];
                    NSString *name = @"本地的相册";
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:image,@"photoImage",name,@"photoName",LOCAIL,@"phototype",nil];
                    [weakSelf.photoModelSubject sendNext:dict];
                }
                
            }else{

            }
        };
        [[SJMyPhotoViewModel defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                                 usingBlock:libraryGroupsEnumeration
                                                               failureBlock:failureblock];
}

@end
