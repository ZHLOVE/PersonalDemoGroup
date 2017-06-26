//
//  NetManager.m
//  MovieQuery
//
//  Created by student on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NetManager.h"

#import "Cinema.h"
#import "Movie.h"
#import <AFNetworking.h>
@implementation NetManager

//请求电影院
+ (void)queryCinemaFromNet:(NSString *)urlStr
        successBlock:(void(^)(NSArray *array))successBlock
           failBlock:(void(^)(NSError *error))failBlock{
    // 请求的manager
    /*
     * desc  : GET请求
     * param : URLString - 请求的地址
     * parameters - 请求参数（GET请求，参数可以为nil 或者 可以提交一个时间戳）
     * success - 请求成功回调的block
     * failure - 请求失败回调的block
     */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // 处理请求成功，服务器返回的JSON数据
             NSArray *array = responseObject[@"result"];
             NSMutableArray *mArray = [[NSMutableArray alloc]init];
             for (NSDictionary *dict in array) {
                 Cinema *cinema = [Cinema dataWithDict:dict];
                 [mArray addObject:cinema];
             }
             successBlock([mArray copy]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             failBlock(error);
         }];
}

//请求电影院的影片信息,通过cinemaid
+ (void)queryMovieWithCinemaID:(NSString *)cinemaid
              successBlock:(void(^)(NSArray *array))successBlock
                 failBlock:(void(^)(NSError *error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/movie/cinemas.movies?key=2273eaf35f8d2efae9a7a634f6f45a8d&cinemaid=%@",cinemaid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // 处理请求成功，服务器返回的JSON数据
             NSDictionary *dict = responseObject[@"result"];
             NSDictionary *array = dict[@"lists"];
             NSMutableArray *mArray = [[NSMutableArray alloc]init];
             for (NSDictionary *dict in array) {
                 Movie *movie = [Movie dataWithDict:dict];
                  NSArray *broadCast = dict[@"broadcast"];
                 for (NSDictionary *dict in broadCast) {
                     movie.hall = dict[@"hall"];
                     movie.price = dict[@"price"];
                     movie.time = dict[@"time"];
                 }
                 NSLog(@"%@%@%@",movie.hall,movie.price,movie.time);
                 [mArray addObject:movie];
             }
             successBlock([mArray copy]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             failBlock(error);
         }];
}
@end
