//
//  ChooseCategpryViewModel.m
//  ShiJia
//
//  Created by 峰 on 2016/12/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "ChooseCategpryViewModel.h"
#import "ChooseCategoryModel.h"

@implementation ChooseCategpryViewModel

-(void)ChooseRequestCategory{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:@"video" forKey:@"type"];
    [parameters setValue:T_STBext forKey:@"STBext"];

    [BaseAFHTTPManager getRequestOperationForHost:SEARCH_HOST
                                         forParam:@"/label.json"
                                    forParameters:parameters
                                       completion:^(id responseObject) {
                                           if ([self.delegate respondsToSelector:@selector(receiveCategoryData:)]) {
                                               [self.delegate receiveCategoryData:[ChooseCategoryModel mj_objectArrayWithKeyValuesArray:responseObject].mutableCopy];
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSString *error) {

                                           if ([self.delegate respondsToSelector:@selector(receiveCategoryError:)]) {
                                               [self.delegate receiveCategoryError:SJERROR(error)];
                                           }
                                       }];
    
}

-(void)RequestChooseItemData:(NSMutableDictionary *)model{
//    SEARCH_HOST
    //@"https://search-formal.ssl.ysten.com:8090/viper-search/"
    [BaseAFHTTPManager getRequestOperationForHost:SEARCH_HOST
                                         forParam:@"/ns.json"
                                    forParameters:model
                                       completion:^(id responseObject) {
                                           if ([self.delegate respondsToSelector:@selector(receiveSearchData:)]) {
                                               searchDataModel *model = [searchDataModel mj_objectWithKeyValues:responseObject];
                                               [self.delegate receiveSearchData:model.programSeries];
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSString *error) {

                                           if ([self.delegate respondsToSelector:@selector(receiveCategoryError:)]) {
                                               [self.delegate receiveCategoryError:SJERROR(@"没有数据")];
                                           }
                                       }];
}

@end
