//
//  def.h
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#ifndef def_h
#define def_h

// 空调的运行模式:制冷 制热 换气(枚举型)
enum AirCondictioningModel
{
    kAirCondictioningModelCold,// => 0
    kAirCondictioningModelHot,// => 1
    kAirCondictioningModelAir,// => 2
    kAirCondictioningModelMax// => 3
};
typedef enum AirCondictioningModel AirCondictioningModel;

// 空调的运行状态:关闭状态 制热中 制冷中 换气中 待机中(制热模式,但室温高于设定温度，制冷模式，但室温低于设定温度)
enum AirCondictioningStatus
{
    kAirCondictioningStatusOff,
    kAirCondictioningStatusHot,
    kAirCondictioningStatusCold,
    kAirCondictioningStatusAir,
    kAirCondictioningStatusWaiting,
    kAirCondictioningStatusMax
};
typedef enum AirCondictioningStatus AirCondictioningStatus;

#endif /* def_h */
