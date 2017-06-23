//
//  ViewController.m
//  BlueToothDemo
//
//  Created by niit on 16/4/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (weak, nonatomic ) IBOutlet                  UITextField          *textField;
@property (weak, nonatomic ) IBOutlet                  UITextView           *resultView;

@property (nonatomic,strong) CBCentralManager *manager;// 中心设备
@property (nonatomic,strong) NSMutableArray   *devices;// 扫描到的外围设备
@property (nonatomic,strong) CBPeripheral     *peripheral;// 当前连上的外围设备
@property (nonatomic,strong) NSMutableArray   *services;// 设备提供的服务对象数组
@property (nonatomic,strong) CBCharacteristic *writeCharacter;// 准备用来控制蓝夜灯颜色的一个特征对象

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 中心管理设备
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // 关于中心 http://blog.csdn.net/dwarven/article/details/37873777
    
    // 外围设备
    self.devices = [NSMutableArray array];
    
    // 设备的服务信息
    self.services = [NSMutableArray array];
    
}

#pragma mark 1. 扫描外设
- (IBAction)scanBtnPressed:(id)sender
{
    // 让中心扫描外设备
    NSLog(@"扫描外围设备");
    [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
}

#pragma mark 2. 连接设备
- (IBAction)connectBtnPressed:(id)sender
{
    int sel = [self.textField.text intValue];
    [self.manager connectPeripheral:self.devices[sel] options:nil];
}

#pragma mark 3. 扫描服务及特征
// 外围设备
//   服务1
//     - 特征1
//     - 特征2
//   服务2
//   服务3
- (IBAction)scanCharBnPressed:(id)sender
{
    [self.peripheral discoverServices:nil];
    self.peripheral.delegate = self;
}

#pragma mark 4. 发送数据
- (IBAction)sendBtnPressed:(id)sender
{
    char bytes[5] = {22,0,0,0,0};
    bytes[1] = arc4random_uniform(255);
    bytes[2] = arc4random_uniform(255);
    bytes[3] = arc4random_uniform(255);
    bytes[4] = arc4random_uniform(255);
    
    NSData *data = [NSData dataWithBytes:bytes length:5];
    
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacter type:CBCharacteristicWriteWithResponse];
}

#pragma mark 5. 断开外围设备
- (IBAction)diconnectBtnPressed:(id)sender
{
    [self.manager cancelPeripheralConnection:self.peripheral];
}


- (void)showInfo:(NSString *)info
{
    NSLog(@"%@",info);
    self.resultView.text = [self.resultView.text stringByAppendingString:info];
    self.resultView.text = [self.resultView.text stringByAppendingString:@"\n"];
}

#pragma mark - 蓝牙中心管理 的 代理方法

#pragma mark 1. 中心设备状态改变的时候触发的方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            [self showInfo:@"蓝牙已打开"];
            break;
        case CBCentralManagerStateUnknown:
            [self showInfo:@"蓝牙 状态位置"];
            break;
        case CBCentralManagerStatePoweredOff:
            [self showInfo:@"蓝牙未打开"];
            break;
        case CBCentralManagerStateResetting:
            [self showInfo:@"蓝牙初始化中"];
            break;
        case CBCentralManagerStateUnsupported:
            [self showInfo:@"蓝牙不支持状态"];
            break;
        case CBCentralManagerStateUnauthorized:
            [self showInfo:@"蓝牙设备未授权"];
            break;
        default:
            break;
    }
    
}

#pragma mark  2. 中心发现外围设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    if(![self.devices containsObject:peripheral])
    {
        // 添加到设备列表数组
        [self.devices addObject:peripheral];
        NSString *msg = [NSString stringWithFormat:@"发现外围设备:%@ RSSI:%@",peripheral,RSSI];
        [self showInfo:msg];
    }

}

#pragma mark 3. 中心连接某个外围设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    NSLog(@"连接成功");
    [self showInfo:@"连接成功"];
    self.peripheral = peripheral;
}

#pragma mark  4. 中心连接外围设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(nonnull CBPeripheral *)peripheral error:(nullable NSError *)error
{
//    NSLog(@"连接失败");
    [self showInfo:@"连接失败"];
}

#pragma mark - 外围设备对象 代理方法
#pragma mark  1. 外围设备 扫描到设备有哪些服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    [self showInfo:@"扫描到服务"];
    
    int i=0;
    for(CBService *s in peripheral.services)
    {
        NSString *msg = [NSString stringWithFormat:@"服务[%i] UUID:%@(%@)",i++,s.UUID.data,s.UUID];
        [self showInfo:msg];
        [self.services addObject:s];
        
        // 扫描外围设备服务下所有特征
        [peripheral discoverCharacteristics:nil forService:s];
    }
    
}

#pragma mark 2. 外围设备 扫描到服务下有哪些特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error
{
    NSString *msg = [NSString stringWithFormat:@"服务[%@]的特征:",service.UUID];
    [self showInfo:msg];
    for(CBCharacteristic *c in service.characteristics)
    {
        msg = [NSString stringWithFormat:@"特征[%@]:(%@),%i",c.UUID.data,c.UUID,c.properties];
        NSLog(@"%@",msg);
        
        if([c.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]])
        {
            // 设备信息信息
        }
        
        // 关于特征:http://blog.csdn.net/dwarven/article/details/37873707
//        CBCharacteristicPropertyBroadcast												= 0x01,       广播
//        CBCharacteristicPropertyRead													= 0x02,       读
//        CBCharacteristicPropertyWriteWithoutResponse									= 0x04,       写，无响应
//        CBCharacteristicPropertyWrite													= 0x08,       写,有相应
//        CBCharacteristicPropertyNotify													= 0x10,   通知
//        CBCharacteristicPropertyIndicate												= 0x20,       声明
//        CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,       通过验证的
//        CBCharacteristicPropertyExtendedProperties										= 0x80,   拓展
//        CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100, 需要加密的通知
//        CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200      需要加密的声明
        if(c.properties == 16)
        {
            // 这个特征是可以订阅
        }
        else if(c.properties == 8)
        {
            // 这个特征是可以写入
        }
        
        NSString *cName =[NSString stringWithFormat:@"%@",c.UUID];
        if([cName isEqualToString:@"FFF1"])// 蓝牙灯的写颜色的特征
        {
            self.writeCharacter = c;
        }
    }
    
}

// 典型 Service UUID
//#define      BLE_UUID_ALERT_NOTIFICATION_SERVICE   0x1811
//#define     BLE_UUID_BATTERY_SERVICE   0x180F
//#define     BLE_UUID_BLOOD_PRESSURE_SERVICE   0x1810
//#define     BLE_UUID_CURRENT_TIME_SERVICE   0x1805
//#define     BLE_UUID_CYCLING_SPEED_AND_CADENCE   0x1816
//#define     BLE_UUID_DEVICE_INFORMATION_SERVICE   0x180A
//#define     BLE_UUID_GLUCOSE_SERVICE   0x1808
//#define     BLE_UUID_HEALTH_THERMOMETER_SERVICE   0x1809
//#define     BLE_UUID_HEART_RATE_SERVICE   0x180D
//#define     BLE_UUID_HUMAN_INTERFACE_DEVICE_SERVICE   0x1812
//#define     BLE_UUID_IMMEDIATE_ALERT_SERVICE   0x1802
//#define     BLE_UUID_LINK_LOSS_SERVICE   0x1803
//#define     BLE_UUID_NEXT_DST_CHANGE_SERVICE   0x1807
//#define     BLE_UUID_PHONE_ALERT_STATUS_SERVICE   0x180E
//#define     BLE_UUID_REFERENCE_TIME_UPDATE_SERVICE   0x1806
//#define     BLE_UUID_RUNNING_SPEED_AND_CADENCE   0x1814
//#define     BLE_UUID_SCAN_PARAMETERS_SERVICE   0x1813
//#define     BLE_UUID_TX_POWER_SERVICE   0x1804
//#define     BLE_UUID_CGM_SERVICE   0x181A
@end
