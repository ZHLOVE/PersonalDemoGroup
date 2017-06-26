//
//  main.m
//  类
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Airplane.h"
#import "Fraction.h"
#import "Complex.h"


#import "Student.h"
#import "Dog.h"
#import "Reward.h"
#import "Round.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
        // 例子1
//        Car *myCar;
//        myCar = [[Car alloc] init];
////        // alloc 是类方法 在堆内存中分配一块空间存放这个对象
////        // init  是实例方法 对这个对象初始化
////        
//        [myCar setColor:@"白色"];
//        [myCar setPrice:100];
//        [myCar setBrand:@"宝马"];
//        [myCar printCarInfo];
////        NSLog(@"我的车是%@的%@,价格:%i万",myCar->color,myCar->brand,myCar->price);
//        NSLog(@"我的车是%@的%@,价格:%i万",[myCar color],[myCar brand],[myCar price]);
//        [myCar drive];
        
        
        // 例子2
//        Fraction *a = [[Fraction alloc] init];
//        Fraction *a = [Fraction new];
        
//        [a setNumerator:1];
//        [a setDenominator:3];
//        [a print];
        
        
//        Fraction *a = [[Fraction alloc] init];
//        printf("a的地址:%p\n",&a);
//        printf("a的值，即指向的地址:%p\n",a);
//        a.numerator = 1;
//        a.denominator = 3;
//        
//        Fraction *b = [[Fraction alloc] init];
//        printf("b的地址:%p\n",&b);
//        printf("b的值，即指向的地址:%p\n",b);
//        b.numerator = 1;
//        b.denominator = 2;
//        
//        [a print];
//        [b print];
//        
//        [a add:b];
//        [a print];
        
        // 练习
        // 1
        // 1)定义一个Student类
        // 实例变量:
        // 学号 姓名 年龄
        // 方法:
        // - (void)printStuInfo;// 打印学生的信息
        
        Student *stu = [[Student alloc] init];
        stu.stuId = 10001;
        stu.stuName = @"小明";
        stu.stuAge = 18;
        
        [stu printInfo];
        
        // 运行时异常错误
        // Student 没有实现printInfo的方法造成的
//    reason: '-[Student printInfo]: unrecognized selector sent to instance 0x1002003e0'
        
        
        
        // 2)在main中用Student定义一个对象
        // 存放一个学生的信息
        // 学号   名字  年龄
        // 10001 李明  18
        
        // 2
        // 定义一个猫类Cat 保存品种 颜色 价格信息，并在main中测试
        
        // 3
        // 定义一个Rectangle矩形类
        // 属性屏幕坐标 x y 长宽 width height
        // 方法:
        // 编写相关setter getter方法
        // printInfo 打印矩形的信息
        
//        复数x被定义为二元有序实数对(a,b)  ，记为z=a+bi,这里a和b是实数，i是虚数单位。在复数a+bi中，a=Re(z)称为实部，b=Im(z)称为虚部。当虚部等于零时，这个复数可以视为实数；当z的虚部不等于零时，实部等于零时，常称z为纯虚数。复数域是实数域的代数闭包，也即任何复系数多项式在复数域中总有根。 复数是由意大利米兰学者卡当在十六世纪首次引入，经过达朗贝尔、棣莫弗、欧拉、高斯等人的工作，此概念逐渐为数学家所接受。
//        复数的四则运算规定为：加法法则：（a+bi）+（c+di）=（a+c）+（b+d）i；减法法则：（a+bi）－（c+di）=（a－c）+（b－d）i；乘法法则：（a+bi）·（c+di）=（ac－bd）+（bc+ad）i；除法法则：（a+bi）÷（c+di）=[（ac+bd）/（c²+d²）]+[（bc-ad）/（c²+d²）]i.
        
        // 4 参考Fraction分数类 编写一个复数Complex类 复数:包含实数部分和虚数部分 比如: 1+5i
        //   定义相应的实例变量
        //   提供设置、打印输出的方法
        // 实现复数的加减乘除功能
        
        
//        Complex *c1 = [[Complex alloc] init];
//        [c1 setReal:3];
//        [c1 setImaginary:5];
//        [c1 print];

        // 5
        //1)定义一个RPG游戏中的人物Hero类
        //定义相关的实例变量、定义相关的setter、getter方法
        //人物的名字 人物的坐标x y
        //人物当前血量hp maxHp
        //提供移动的方法
        //-(void)move:(int)direction;//调用后人物的x,y相应加减
        //2)定义一个rpg游戏类中的怪物Monster类
        //怪物的属性:怪物名字 怪物的hp maxHp 怪物的坐标x,y
        //-(void)move:(int)direction;
        //3)在main()中测试
        //流程:
        //a 创建Hero的实例对象aHero 设定坐标0,0 hp=10 mp=10
        //b 创建怪物的实例对象aMonster 怪物的设定坐标为随机(范围0~10，0~10) hp在(10~20随机)
        //while(1)
        //            {
        //                显示人物信息(名字、当前坐标)
        //                显示怪物信息(怪物名字、当前坐标)
        //
        //                int direct;//方向
        //                scanf(“ %i”,&direct);//根据玩家输入的方向控制aHero走动
        //                [aHero move:direct];
        //                [aMonster move:arc4Random%4];//怪物随机往一个方向走动
        //
        //                if(aHero的坐标是否等于aMonster的坐标)
        //                {
        //                    NSLog("游戏胜利！");
        //                    break;
        //                }
        //             }
        
        
        // 编写以下类，并在main中测试:
        // 1 狗类
        // 属性:
        // 颜色
        // 名字
        // 体重Kg
        // 方法:
        // 吃(每吃一次，体重增加0.5kg，吃完后显示一下当前体重)
        // 叫唤(打印输出@"汪~汪")
        Dog *d1 = [[Dog alloc] init];
        d1.name = @"阿黄";
        d1.color = kDogColorBlackWhite;
        d1.weight = 20.0;
        
        
        Dog *d2 = [[Dog alloc] init];
        d2.name = @"阿花";
        d2.color = kDogColorWhite;
        d2.weight = 20.0;
        [d2 printInfo];
        
        [d1 eat];
        [d2 eat];
        [d2 eat];
        [d2 eat];
        [d1 sing];
        
        // 2 学生成绩类
        // 属性:
        // 学号 姓名 英语 数学 语文 成绩
        // 方法:
        // 得到总分
        // 得到平均分
        // 打印学生成绩信息
        // 如:10001 小明 英语:100  数学:90 语文:80 总分:270 平均分:90
        Reward *r = [[Reward alloc] init];
        // 属性不是变量，它会帮你生成相关的代码
        // 在给属性赋值的时候 调用的是setter方法
        // 调用属性的时候 调用的getter方法
//        r.stuId = 10001; // 实际上运行的是: [r setStuId:10001];
//        NSLog(@"%i",r.stuId);//实际上运行的是: NSLog(@"%i",[r stuId]);
//        r.stuName = @"小明";
//        r.english = 100;
//        r.math = 90;
//        r.chinese = 80;
//        [r printInfo];
    
        
        // 3 舰艇类
        // 属性:
        // 名字
        // 当前航速(<最大航速,>=0)
        // 最大航速(<200码)
        // 方法:
        // 开动(如果当前航速=0，则设置航速设置为10,否则不产生任何效果)
        // 加速(航速+=10,并方法返回当前航速)
        // 减速(航速-=10,并方法返回当前航速)
        
        // 创建一个舰艇的对象进行测试
        // 比如:拿破仑号 最大航速150码 起始航速0码
        // 开动它
        // 加速到最大航速
        // 再减速到停止
        
        // 4 定义一个储蓄卡类，提供存入钱，取出钱的方法。(储蓄卡不可透支)
        
        
        // 5 定义一个信用卡类，开始设定信用额度，提供刷卡消费的方法，提供还款的方法.(信用卡可透支，但不可超过信用额度)
        
        // 6 定义一个房地产信息的类能存储以下信息
        //   房产地址(字符串)  户型(字符串) 均价(元/平方米 整数)  所在楼层(整数，不可超过)  最高楼层
        
        // 7 定义一个界面上的圆形类
        // 中心点在屏幕上的坐标、半径
        // 提供 计算周长、面积的方法
        Round *round = [[Round alloc] init];//空对象
        
        // *注意: 如果某属性是结构体变量，结构体变量的子变量不能单独给其赋值
//        round.x = 100;// 向空对象发送消息 也不会报错，不会有任何效果
//        round.y = 200;
        // 在给属性赋值的时候 调用的是setter方法
//        round.center.x = 100;// => [round setCenter:.x]; // 错误！
//        round.center.y = 200;// => [round.setCenter:.y]; // 错误！
        MyPoint p;
        p.x = 100;
        p.y = 200;
        round.center = p;
        
        round.r = 50;
        
        NSLog(@"圆的面积:%g 周长:%g",[round area],[round perimeter]);
        
        // 8 定义一个空调类
        // 空调开关状态
        // 空调的运行模式:制冷 制热 换气(枚举型)
        // 空调的运行状态:关闭状态 制热中 制冷中 换气中 待机中(制热模式,但室温高于设定温度，制冷模式，但室温低于设定温度)
        // 空调设定制冷制热温度值
        // 当前室温(-10~40度)
        // 风速(1~5)档
        
        // 方法:
        // 显示信息（显示空调所有的信息）
        // 打开关闭空调(然后调用显示信息)
        // 设定运行模式(然后调用显示信息)
        // *调高设定温度(根据不同模式和当前室温,需要改变当前空调的运行状态)(然后调用显示信息)
        // *调低设定温度(根据不同模式和当前室温,需要改变当前空调的运行状态)(然后调用显示信息)
        // 调高风速(然后调用显示信息)
        // 调低风速(然后调用显示信息)
        // 得到当前室温(第一次获取时在正常范围内随机值,再获取时在原先基础上随机+-0.5度) // 可通过改写getter方法
        
        // 9 定义一个扑克牌类Poke
        // 方法:
        // 设定扑克牌是什么牌
        // 显示这张扑克牌的信息
        // 传入另一张牌,比较大小。显示比较结果:大 相等 小 (数字牌根据牌面数字，另外大鬼>小鬼>数字牌)
        // 比如当前牌，是草花5, 传入一张黑桃6的牌，显示: 草花5 小于 黑桃6
        
        // 10 编写一个整数累计计算器类 Calc
        // 提供 加减乘除 清空的功能
        //用一下代码测试
//        Calc *calc = [[Calc alloc] init];
//        [calc clear];             //        清除,初始值设置为0
//        NSLog(@"%i",[calc add:5]);//显示5   //0 + 5 = 5
//        NSLog(@"%i",[calc sub:2]);//显示3   //5 - 2 = 3
//        NSLog(@"%i",[calc mul:6]);//显示18  //3 * 6 = 18
//        NSLog(@"%i",[calc div:3]);//显示6   //18 / 3 = 6
//        NSLog(@"%i",[calc mod:5]);//显示61  //6 %  5 = 1 求余
        
#pragma mark -
        // 如果要让用户输入字符串，存到NSString中，可用以下代码
//        char name[20];
//        printf("请输入学生名字:");
//        scanf("%s",name);
//        NSString *stuName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];// C字符串数组 => NSString对象
//        NSLog(@"%@",stuName);
        
//        定义一个电视机类TV
//        
//        提供
//        1 开关电视的功能
//        2 选台功能(+ -) （当前台的频道不可超过最大频道数量，最大频道数要可以修改的，默认最大有100个频道）
//        3 调节音量功能（+ -） (默认100个等级)
//        4 静音
//        5 调节亮度(+ -) (默认100个等级)
//        6 调节对比度(+ -) (默认100个等级)
//        5 切换到预制的色彩模式(有以下模式:正常模式、影院模式、高亮模式)
//        正常模式 对比度50 亮度50
//        影院模式 对比度70 亮度40
//        高亮模式 对比度95 亮度95
//        
//        在main中测试,每次操作后,显示一下电视机的当前状态
//        1 创建一台电视机
//        2 打开电视机
//        3 调节到第5个频道
//        4 调节音量到50
//        5 静音
//        6 切换到高亮模式
//        7 关闭电视
        
        
    }
    return 0;
}
