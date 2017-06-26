//
//  ViewController.m
//  WhereAmI
//
//  Created by niit on 16/4/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Place.h"
@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
// 经度
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;;
// 纬度
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;

// 位置管理器
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

//kCLLocationAccuracyBestForNavigation  最适合导航
//kCLLocationAccuracyBest               最好
//kCLLocationAccuracyNearestTenMeters   10米
//kCLLocationAccuracyHundredMeters      100米
//kCLLocationAccuracyKilometer          1000米
//kCLLocationAccuracyThreeKilometers    3000米

// 需要在Info.plist中加一项
// NSLocationWhenInUseUsageDescription App在前台定位需要获取用户权限的说明
// NSLocationAlwaysUsageDescription    App在后台定位需要获取用户权限的说明

// 国家软件园经纬度 (31.4870,120,3672)

- (IBAction)btnPresssed:(id)sender
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    // 定位精度设置(精度越高，耗电越多)
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 代理人
    self.locationManager.delegate = self;
    // 更新位置距离设定(每隔多少米定位一次)
    self.locationManager.distanceFilter = 100.0f;// 如果在100米范围内移动，不会刷新位置
    // 请求用户给与访问位置信息的权限
    [self.locationManager requestWhenInUseAuthorization];
    // 启动定位
    [self.locationManager startUpdatingLocation];
}

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(nonnull CLLocation *)newLocation
//           fromLocation:(nonnull CLLocation *)oldLocation
//{
//    // 1 将得到的经纬度显示到界面
//    self.longitudeLabel.text = [NSString stringWithFormat:@"%.5f",newLocation.coordinate.longitude];
//    self.latitudeLabel.text = [NSString stringWithFormat:@"%.5f",newLocation.coordinate.latitude];
//    
//    // 2. 如果不需要时及时关闭定位的更新(减少耗电)
//    [self.locationManager stopUpdatingLocation];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    //
//    newLocation.coordinate 经纬度
//    newLocation.altitude 海拔高度
//    newLocation.course 航向
//    newLocation.speed 速度
    
    // 1 将得到的经纬度显示到界面
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.5f",newLocation.coordinate.longitude];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%.5f",newLocation.coordinate.latitude];
    NSLog(@"%.5f,%.5f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    // 2. 如果不需要时及时关闭定位的更新(减少耗电)
//    [self.locationManager stopUpdatingLocation];
    //2 设定地图大小
    //范围大小
    MKCoordinateSpan span = {0.1,0.1};//地图显示范围的大小
    //区域
    MKCoordinateRegion region = {newLocation.coordinate,span};// 显示的范围
    [self.mapView setRegion:region];
    //3 根据经纬度惊喜- >位置信息（从网络上获取）
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];//位置解析的对象
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = [placemarks lastObject];
        NSLog(@"位置名称:%@",place.name);
        NSLog(@"位置街道:%@",place.thoroughfare);
        NSLog(@"位置子街道:%@",place.subThoroughfare);
        NSLog(@"位置区:%@",place.subLocality);
        NSLog(@"位置城市:%@",place.locality);
        NSLog(@"位置国家:%@",place.country);
    }];
    //4添加标注
    Place *myPlace = [[Place alloc] init];
    myPlace.coordinate = newLocation.coordinate;
    myPlace.title = @"我的工作地点";
    myPlace.subtitle = @"震泽路18号";
    [self.mapView addAnnotation:myPlace];
}

// 为地图上的标注提供数据及设定
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKPinAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Anntotaion"];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Anntotaion"];
    }
    pinView.pinTintColor = [UIColor blueColor];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;//显示弹出信息
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    btn.tag  = 101;
    [btn addTarget:self action:@selector(pinBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = btn;
    return pinView;
}

- (void)pinBtnPressed:(UIButton *)btn
{
    NSLog(@"%s",__func__);
    [self performSegueWithIdentifier:@"gotoDetailInfoVC" sender:nil];
}






















@end
