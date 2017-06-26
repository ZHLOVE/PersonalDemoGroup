//
//  CellTableView.h
//  YLWeather
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CityWeatherInfo.h"
#import "CityWeatherInfo.h"
@interface CellTableView : UITableViewCell


@property (nonatomic,weak) CityWeatherInfo *cityCell;

@property (weak, nonatomic) IBOutlet UILabel *quName;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *tem1;
@property (weak, nonatomic) IBOutlet UILabel *tem2;
@property (weak, nonatomic) IBOutlet UILabel *windState;


@end
