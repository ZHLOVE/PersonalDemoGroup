//
//  CellTableView.m
//  YLWeather
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CellTableView.h"


@implementation CellTableView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCityCell:(CityWeatherInfo *)cityCell{
    self.quName.text = cityCell.quName;
    self.cityName.text = cityCell.cityname;
    self.tem1.text = cityCell.tem1;
    self.tem2.text = cityCell.tem2;
    self.windState.text = cityCell.windState;
}

@end
