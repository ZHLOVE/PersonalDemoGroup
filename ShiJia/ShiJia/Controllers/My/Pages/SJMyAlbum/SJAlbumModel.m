//
//  SJAlbumModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJAlbumModel.h"

@implementation SJAlbumModel
+(NSDictionary *)objectClassInArray{

    return @{@"albumList":[CloudAlbumModel class] };
}
    
@end
@implementation SJAlbumRequestModel

@end
@implementation CloudAlbumModel

@end
@implementation CloudRequestPhotoModel

@end

@implementation CloudPhotoModel

@end

@implementation AddPhotoRequestModel

@end

@implementation AddResponseModel

@end

@implementation DeletePhotoRequestModel

@end
@implementation DeleteResponse

@end
@implementation SJAlbumUserInfoModel

@end
@implementation RequestUserInfoModel 

@end

