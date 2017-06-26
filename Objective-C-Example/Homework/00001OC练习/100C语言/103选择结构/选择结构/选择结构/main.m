//
//  main.m
//  选择结构
//
//  Created by niit on 15/12/16.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

float profit(float n){
    if (n<=10) {
        return n*0.1;
    }
    else if (n<=20){
        return (n-10)*0.075+profit(10);
    }
    else if (n<=40){
        return (n-20)*0.05+profit(20);
    }
    else if (n<=60){
        return (n-40)*0.03+profit(40);
    }
    else if (n<=100){
        return (n-60)*0.015+profit(60);
    }
    else{
        return (n-100)*0.01+profit(100);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

#pragma mark - 1 if语句
        
        // 求绝对值的
//        int num;
//        printf("请输入一个整数:");
//        scanf("%d",&num);
//        if(num<0) // num < 0 判断表达式
//            num = -num;
//        printf("绝对值是:%i",num);
        
#pragma mark - 2 if ... else 语句
        
        // 判断奇数还是偶数
//        int num;
//        printf("请输入一个整数:");
//        scanf("%d",&num);
//        if(num%2 == 0)
//        {
//            printf("是偶数\n");
//        }
//        else
//        {
//            printf("是奇数\n");
//        }
        
#pragma mark - 3 if ... elseif ... else 语句
        
        // 判断是正数还是负数还是0
//        int num;
//        printf("请输入一个整数:");
//        scanf("%d",&num);
//        if(num<0)
//        {
//            printf("是负数\n");
//        }
//        else if(num>0)
//        {
//            printf("是正数\n");
//        }
//        else
//        {
//            printf("是零\n");
//        }
        
        // 练习:
        // 1 输入一个学生的成绩 输出评价
        // 不在0~100范围内,提示"请输入正确的成绩"
        // 优秀(85以上）
        // 良好(76~85)
        // 中等(60~75)
        // 不及格(60以下)
//        int score;
//        printf("请输入一个学生的成绩:");
//        scanf("%d",&score);
//        if(score<0 || score>100)
//        {
//            printf("请输入正确的成绩");
//        }
//        else if(score>85)
//        {
//            printf("优秀");
//        }
//        else if(score>75)
//        {
//            printf("良好");
//        }
//        else if(score>=60)
//        {
//            printf("中等");
//        }
//        else
//        {
//            printf("不及格");
//        }
        
        // 2 输入一个年份，判断是否是闰年。（闰年的条件：如果是整百数，必须是400的倍数，否则4的倍数就是闰年)
        
//        int year;
//        printf("请输入一个年份:");
//        scanf("%d",&year);
//        if(year%100 == 0)
//        {
//            if(year%400 == 0)
//            {
//                printf("闰年\n");
//            }
//            else
//            {
//                printf("不是闰年\n");
//            }
//        }
//        else
//        {
//            if(year%4 == 0)
//            {
//                printf("闰年\n");
//            }
//            else
//            {
//                printf("不是闰年\n");
//            }
//        }
        
//        if((year%400==0) || (year%100 != 0&&year%4 == 0) )
//        {
//            printf("闰年\n");
//        }
//        else
//        {
//            printf("不是闰年\n");
//        }
        
#pragma mark - 4 switch
        
//        switch(表达式)
//        {
//        case 值1：
//            程序代码段1
//            break;
//        case 值2:
//            程序代码段2
//            break;
//            ...依次类推
//        default:
//            程序段n
//        }
        
        //制作一个猜拳游戏 0代表石头 1代表剪子 2代表布
        
//        int playerHand;
//        printf("玩家出拳(0石头1剪子2布):");
//        scanf("%d",&playerHand);
//        
//        switch (playerHand) {
//            case 0:
//                printf("玩家出的是石头");
//                break;// 跳出switch
//            case 1:
//                printf("玩家出的是剪子");
//                break;
//            case 2:
//                printf("玩家出的是布");
//                break;
//                
//            default:// 前边条件都不满足则执行default下的语句
//                printf("请输入正确的出拳");
//                break;
//        }
//        printf("\n");
//        
//        int computerHand = arc4random()%3;//0 1 2
//        switch (computerHand) {
//            case 0:
//                printf("电脑出的是石头");
//                break;
//            case 1:
//                printf("电脑出的是剪子");
//                break;
//            case 2:
//                printf("电脑出的是布");
//                break;
//                
//            default:
//                break;
//        }
//        printf("\n");
        
        // 练习
        // 1 判断电脑输赢了还是输了.
//        int playerhand;
//        printf("玩家出拳(0石头1剪刀2布)：");
//        scanf("%d",&playerhand);
//        switch (playerhand) {
//            case 0:
//                printf("玩家出的是石头");
//                break;
//            case 1:
//                printf("玩家出的是剪刀");
//                break;
//            case 2:
//                printf("玩家出的是布");
//                break;
//                
//            default:
//                printf("请输入正确的数字");
//                break;
//        }
//        printf("\n");
//        
//        int comhand=arc4random()%3;
//        switch (comhand) {
//            case 0:
//                printf("电脑出的是石头");
//                break;
//            case 1:
//                printf("电脑出的是剪刀");
//                break;
//            case 2:
//                printf("电脑出的是布");
//                break;
//                
//            default:
//                
//                break;
//        }
//        printf("\n");
//        
//        if (comhand==playerhand){
//            printf("打平");
//        }else{
//            if (comhand==0){
//                if(playerhand==1){
//                    printf("电脑赢");
//                }else{
//                    printf("玩家赢");
//                }
//                
//            }else if(comhand==1){
//                if (playerhand==0){
//                    printf("玩家赢");
//                }else{
//                    printf("电脑赢");
//                }
//            }else{
//                if (playerhand==0) {
//                    printf("电脑赢");
//                }else{
//                    printf("玩家赢");
//                }
//            }
//            printf("\n");
//        }
        
        
        // 2 输入一个学生的成绩 输出评价
        // 不在0~100范围内,提示"请输入正确的成绩"
        // 优秀(80~100）
        // 良好(70~79)
        // 中等(60~69)
        // 不及格(0~59)
        // 想办法用switch实现
//        int score;
//        NSLog(@"请输入学生成绩");
//        scanf("%d",&score);
//        if (score<0 || score>100)
//        {
//            NSLog(@"输入有误");
//        }
//        else
//        {
//            switch (score/10)
//            {
//                case 10:
//                case 9:
//                case 8:
//                    NSLog(@"优秀");
//                    break;
//                case 7:
//                    NSLog(@"良好");
//                    break;
//                case 6:
//                    NSLog(@"及格");
//                    break;
//                default:
//                    NSLog(@"不及格");
//                    break;
//            }
//        }

        
        // 3
        // int a,b;
        // char c;// 保存运算符号
        // 让用户输入 a b
        // 让用户输入 c (+ - * /这四种符号)
        // 根据c的符号，显示a和b计算的结果
//        scanf("%c",&c);
        
#pragma mark - 随机数
        
        // C语言里的随机数
//        srand(time(NULL));
//        printf("%i\n",rand());
        
//        printf("%u\n",arc4random());
//        
//        // 0~2
//        int n;
//        n = arc4random()%3;
//        printf("0~2随机数: %i\n",n);
//        
//        // 0~9
//        n = arc4random()%10;
//        printf("0~9随机数:%i\n",n);
//        
//        // 1~10
//        n = arc4random()%10+1;
//        printf("1~10随机数%i\n",n);
//        
//        // 练习
//        // 1 得到以下范围内的随机数
//        // 0~100
//        n = arc4random()%101;
//        printf("0%d\n",n);
//        // 0~99
//        n = arc4random()%100;
//        printf("%d\n",n);
//        // -5 ~ 4
//        int c = arc4random()%10 - 5;
//        printf("-5~4随机数:%i\n",c);
//        // -50 ~ 40
//        int n3;
//        n3=(int)(arc4random()%91)-50;
//        printf("-50~40的随机数：%i\n",n3);
//        // -5.0 -4.9 -4.8 -4.7 ... 4.0
//        //arc4random() 是返回的是无符号的整型，求余后转int型可以确保不出错。
//        float n2 = ((int)(arc4random()%91)-50)/10.0;
//        printf("-5.0~4.0的随机数%.1f\n",n2);
        
        // 随机一个无锡气温的值 范围是 -5.0摄氏度 ~ 45.0摄氏度
        
        // 2 随机显示一张扑克牌，并显示这张扑克牌的信息,
        //例如:
        //♠️A 2 ... J Q K  13张
        //♥️
        //♣️
        //♦️
        //大鬼 小鬼
    
        //printf("♠️♣️♥️♦️");
        int card = arc4random()%54;
        int huase = card/13;
        int num = card%13;
        
    
        switch (huase) {
            case 0:
                printf("♠️");
                break;
            case 1:
                printf("♥️");
                break;
            case 2:
                printf("♣️");
                break;
            case 3:
                printf("♦️");
                break;
            default:
                if(num==0)
                {
                    printf("大鬼");
                }
                else
                {
                    printf("小鬼");
                }
                break;
        }
        if(huase<4)
        {
            switch (num) {
                case 0:
                    printf("A");
                    break;
                case 10:
                    printf("J");
                    break;
                case 11:
                    printf("Q");
                    break;
                case 12:
                    printf("K");
                    break;
                default:
                    printf("%i",num+1);
                    break;
            }
        }
        
        
        
        

#pragma mark - 布尔值
        
//        BOOL a = YES;//
//        int x = 100;
//        int y = 200;
//        a = x>y; // NO
//        
//        printf("%i\n",a);
//        printf("%s\n",a?"真":"假");
//        NSLog(@"%@\n",a?@"真":@"假");
        
#pragma mark - 三元表达式
        // 判断表达式 ? 结果1 : 结果2
        
//        int year;
//        printf("请输入年份:");
//        scanf("%d",&year);
//        printf("%s闰年\n",((year%400==0) ||(year%100 != 0&&year%4 == 0)) ? "是" : "不是");
//
        // 练习 使用三元表达式
        // 1 输入一个数,判断输出是奇数还是偶数
        
        // 2 输入一个成绩，的判断输出是及格还是不及格
        
        // 3 输入一个数,判断输出是正数还是负数还是零(2层嵌套)
//        int x;
//        scanf("%d",&x);
//        printf("%s\n", x==0 ? "零" : (x>0?"正数":"负数"));
        
        // 4 用户输入x,y,z,打印最大值(2层嵌套)
        

#pragma mark - 综合练习
        // 填空题:
        // 表达式 (6>5>4)+(float)(3/2) 的值是___1.0________?
        //
        
        
        // 1
        // 1)随机得到一个日期(年月日) 年份(0~3000),月份日期也要合理，并要考虑闰年
        // 2)计算这一天是这一年的第几天
        
        // 2 输入三个整数x,y,z,把这三个数由小到大输出
        int x,y,z;
        
        // 3 企业发放的奖金根据利润提成。利润(I)低于或等于10万元时，奖金可提10%；利润高于10万元，低于20万元时，低于10万元的部分按10%提成，高于10万元的部分，可可提成7.5%；20万到40万之间时，高于20万元的部分，可提成5%；40万到60万之间时高于40万元的部分，可提成3%；60万到100万之间时，高于60万元的部分，可提成1.5%，高于100万元时，超过100万元的部分按1%提成，从键盘输入当月利润I，求应发放奖金总数？
        //5
        //10
        //15
        //20
        //25
        //40
        //50
        //60
        //80
        //100
        //150
//        printf("5w 奖金:%f\n",profit(5));
//        printf("10w 奖金:%f\n",profit(10));
//        printf("15w 奖金:%f\n",profit(15));
//        printf("20w 奖金:%f\n",profit(20));
//        printf("25w 奖金:%f\n",profit(25));
//        printf("40w 奖金:%f\n",profit(40));
//        printf("50w 奖金:%f\n",profit(50));
//        printf("60w 奖金:%f\n",profit(60));
//        printf("80w 奖金:%f\n",profit(80));
//        printf("100w 奖金:%f\n",profit(100));
//        printf("150w 奖金:%f\n",profit(150));
        
//        5w 奖金:0.500000
//        10w 奖金:1.000000
//        15w 奖金:1.375000
//        20w 奖金:1.750000
//        25w 奖金:2.000000
//        40w 奖金:2.750000
//        50w 奖金:3.050000
//        60w 奖金:3.350000
//        80w 奖金:3.650000
//        100w 奖金:3.950000
//        150w 奖金:4.450000
        
        
        // 4 输入一个字符,判断是字母还是数字还是特殊字符
        // 说明:
        // 字符在内存中是以ASC码来保存的
        // a-z 97-122
        // A-Z 65-90
        // 0-9 48-57
        
        
//        char c;
//        printf("请输入+-*/符号:");
//        scanf("%c",&c);
//        printf("用户输入的是:%c\n",c);
//        int a;
//        int b;
//        scanf("%d,%d",&a,&b);
//        if(c == '+')
//        {
//            printf("进行加法运算\n");
//            printf("结果是:%d",a+b);
//        }
//        else if(c == '-')
//        {
//            printf("进行减法运算\n");
//            printf("结果是:%d",a-b);
//        }
        
        
    }
    return 0;
}
