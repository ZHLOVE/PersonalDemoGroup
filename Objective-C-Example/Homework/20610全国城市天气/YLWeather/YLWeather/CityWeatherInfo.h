//
//  CityWeatherInfo.h
//  YLWeather
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

//<city quName= pyName= cityname= state1= state2= stateDetailed= tem1= tem2= windState= />
//<city cityX= cityY= cityname= centername= fontColor= pyName= state1= state2= stateDetailed= tem1= tem2= temNow= windState= windDir= windPower= humidity= time= url= />
//<city cityX= cityY= cityname= centername= fontColor= pyName= state1= state2= stateDetailed= tem1= tem2= temNow= windState= windDir= windPower= humidity= time= url= />
#import <Foundation/Foundation.h>

@interface CityWeatherInfo : NSObject

@property(nonatomic,copy) NSString *quName,*pyName,*cityname,*state1,*state2,*stateDetailed,*tem1,*tem2,*windState,*cityX,*cityY,*centername,*fontColor,*temNow,*windDir,*windPower,*humidity,*time,*url;

//初始化
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)weatherInfoWithDict:(NSDictionary *)dict;
@end
