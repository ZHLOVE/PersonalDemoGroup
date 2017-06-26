//
//  main.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClassB.h"

#import "Animal.h"
#import "Cat.h"
#import "Dog.h"

#import "SmallBoat.h"
#import "Rectangle.h"

#import "Card.h"
#import "CreditCard.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // ClassA 是 NSObject的子类(,派生类)
        // ClassB 是 ClassA的子类,ClassA是ClassB的父类(超类superclass)
        
//        ClassB *b = [[ClassB alloc] init];
//        [b initVal];
//        [b printInfo];
        
        // 练习
        // 定义一个Animal动物类
        // 属性
        //  name //名字
        // 方法
        //  sing //唱歌
        // 定义:猫类Cat 狗类Dog,他们的名字不同，唱歌方式不同
        
//        Animal *aAnimal = [[Animal alloc] init];
//        [aAnimal sing];
        
        Cat *aCat = [[Cat alloc] init];
        [aCat sing];
        
        Dog *aDog = [[Dog alloc] init];
        [aDog sing];
        
        
        //练习:
        //1定义一个船类
        //NSString *name;//船名字
        //int speed;//航速
        //- (void)printInfo();//打印船信息
        //定义小木船类 继承自船类
        //航速10 在初始化方法中 对name和航速进行设置
        //定义快艇类 继承自船
        //航速50
        //定义军舰类 继承自船
        //航速80
        //在main中测试
        SmallBoat *boat = [[SmallBoat alloc] init];
        [boat printInfo];
        
        
        //2定义一个借记卡类
        //提供 存款、取现、查询功能
        //派生一个信用卡类
        //可以设置透支额度，取现可以透支
        //在初始化方法中 设置透支额度
        //在main中测试
//        Card *c = [[Card alloc] init];
//        [c pickupMoney:100];
//        
//        [c addMoney:200];
//        [c addMoney:200];
//        [c pickupMoney:500];
//        [c pickupMoney:100];
        
        CreditCard *c = [[CreditCard alloc] init];
        [c pickupMoney:1000];
        [c pickupMoney:1000];
        [c pickupMoney:1000];
        [c pickupMoney:5000];
        [c addMoney:3000];
        
        CreditCard *c2 = [[CreditCard alloc] initWithCredit:10000];
        
        //3定义一个游戏角色Role通用类
        //坐标 x,y name
        //方法:
        //- (void)move:(EDirection)tmpDirection;//移动
        //定义一个Hero类从Role继承
        //初始化方法随机坐标(x,y) name设置为"玩家"
        //定义一个Monster从Role继承
        //写初始化方法 随机坐标x y name设置为"野猪怪"
        //地图大小(10,10)
        //在main中测试
        
        //4定义一个长方形类 Rectangle
        //属性:长 宽
        //方法:
        //- (id)initWithWidth:(int)w andHeight:(int)h;
        //- (int)area;//求面积
        //- (int)perimetter;求周长
        //派生一个正方形类Square
        //在main中测试
//        Rectangle *r=[[Rectangle alloc] initWithWidth:5 andHeight:10];
        Rectangle *r=[Rectangle rectangleWithWidth:5 andHeight:10];
        
        NSLog(@"长方形的面积:%i 周长:%i",[r area],[r perimeter]);
        
        // 重写setSide方法，把数值值存到宽和高中，这样area perimeter能正常使用
        //        Square *s=[[Square alloc] init];
        //        s.side=20;//-> [s setSide:20];
        //        NSLog(@"正方形的面积:%i 周长:%i",[s area],[s perimeter]);
        
#pragma mark - 类方法与实例方法 初始化对象
        int i=10;
        // 下面两行代码功能相同，都是创建字符串@"i=10"
        NSString *str1 = [[NSString alloc] initWithFormat:@"i=%i",i]; // 创建之后，实例方法初始化
        NSString *str2 = [NSString stringWithFormat:@"i=%i",i];// 直接调用类方法,创建并初始化
        
        // 练习:
        // 定义一个Student
        // 学号 姓名 年龄
        // 编写同时传入学号、姓名、年龄的实例初始化方法、及类方法
        
        // 定义一个Person类
        //名字 年龄 身高(cm) 体重(kg)
        //- (id)initWithName:(NSString *)n andAge:(int)a
        //    andHeight:(int)h andWeight:(int)w;
        //重载各属性的setter方法，对其输入值进行合理化判断。年龄1~150 身高1~300 体重1~400,如果不在合理范围，NSLog打印警告信息，值置最小值
        //在main这种测试
//        Person *p=[[Person alloc] initWithName:@"小明" andAge:200 andHeight:170 andWeight:100];
//        [p printInfo];

    }
    return 0;
}
