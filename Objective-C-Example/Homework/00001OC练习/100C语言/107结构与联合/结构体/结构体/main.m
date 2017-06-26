//
//  main.m
//  结构体
//
//  Created by niit on 15/12/22.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义结构体Date
struct Date
{
    int year;
    int month;
    int day;
};

//typedef 定义别名
//typedef 已存在的类型 新的名字
typedef struct Date Date;// struct Date -> Date

// 练习
// 1
// 1)定义一个学生结构体 Student
// 学号 unsigned int
// 性别 BOOL
// 年龄 unsigned int
// 体重(kg) unsinged int
// 身高(cm) unsigned int
// 2)并定义别名
// 3)定义一个学生变量,存入以下信息
// 10001 男 18 65 175
// 4)自己计算需要使用多少内存存放这个结构体变量,然后再使用sizeof()查看它占用了多少内存字节
typedef struct Student
{
    long int stuId;// 8
    BOOL stuSex;// 1 -> 4
    char name[7];// 7 -> 8
    unsigned int stuAge;// 4
    unsigned int stuWeight;// 4
    unsigned int stuHeight;// 4
}Student;
// 字节对齐
// 结构体的总大小为结构体最宽基本类型成员大小的整数倍，如有需要编译器会在最末一个成员之后加上填充字节

struct packed {
    unsigned int f1:1;// 二进制位
    unsigned int f2:1;
    unsigned int f3:1;
    unsigned int type:4;
    unsigned int index:9;
};

// 联合体 共用内存
union Mixed
{
    char a;
    float f;
    int x;
    int y;
};
typedef union Mixed Mixed;


struct TeacherInfo
{
    int teachId;// 工号
    int workYear;// 工作年限
    char department[20];// 部门
};
struct StudentInfo
{
    int stuId;// 学号
    char stuClass[20];// 班级名称
};
union Info
{
    struct TeacherInfo teacherInfo;
    struct StudentInfo studentInfo;
};
struct Person
{
    BOOL type;// 老师/学生
    int age;// 年龄
    char name[20];// 姓名
    union Info info;// 人的信息
};


int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
        // 1
        Date today = {2015,12,22};
//        today.year = 2015;
//        today.month = 12;
//        today.day = 22;
        
        Date tomorrow;
        tomorrow.year = today.year;
        tomorrow.month = today.month;
        tomorrow.day = today.day+1;
        
        NSLog(@"%i-%i-%i",tomorrow.year,tomorrow.month,tomorrow.day);

        // 2
        Student stu;
        stu.stuId = 10001;
        stu.stuSex = YES;
        stu.stuAge = 18;
        stu.stuWeight = 65;
        stu.stuHeight = 175;
        
        NSLog(@"%i:%@ %i岁 %iKG %icm ",stu.stuId,stu.stuSex?@"男":@"女",stu.stuAge,stu.stuWeight,stu.stuHeight);
        NSLog(@"%i",sizeof(Student));
        
        printf("sizeof(struct packed)=%li\n",sizeof(struct packed));
        
        
        Mixed m;
        m.a = 'a';
        m.x = 100;
        printf("%c,%f,%i,%i\n",m.a,m.f,m.x,m.y);
        
        
        struct Person person[10];
        
        // 老师信息
//        1 陈老师 男 10001 3 教学部
        // 学生信息
//        2 张三  男  150101 “高一一班”
        person[0].type = 1;
        strcpy(person[0].name,"陈");// c语言里字符串拷贝的函数
        person[0].info.teacherInfo.teachId = 10001;
        person[0].info.teacherInfo.workYear = 3;
        strcpy(person[0].info.teacherInfo.department,"教学部");
        
        person[1].type = 0;
        strcpy(person[1].name,"张三");// c语言里字符串拷贝的函数
        person[1].info.studentInfo.stuId= 150101;
        strcpy(person[1].info.studentInfo.stuClass,"教学部");
        
        
        for (int i=0; i<2; i++)
        {
            if(person[i].type)
            {
                // 按照老师的方式去打印
            }
            else
            {
                // 按照学生的方式去打印
            }
        }
        
        // 游戏

        // 定义一个游戏的角色结构体 GameRole
        // {
        //   角色类型 玩家|怪物
        //   坐标信息 x y
        //   血量 hp/maxhp
        //   角色信息 info;// 联合体类型变量
        // }
        // 怪物、玩家
        //

        //GameRole role[4];
        //定义一个结构体数组存放以下所有游戏内角色的信息信息，并遍历打印

        // 角色类型  坐标x 坐标y  血量 最大血量  角色信息
        //                                  英雄名字   年龄   等级       经验值
        // 英雄      0    0     100  100     "小明"    18岁   等级10级   2346
        //                                  怪物名字    怪物对话信息
        // 小怪物    10   5     20    20     "野猪怪"    "哼(ˉ(∞)ˉ)唧"
        // 小怪物    5    5     40    40     "猪头怪物"  "哈哈哈哈哈！"
        // BOSS     5    4     50    50     "猪头精"    "我是BOSS~"
        
        
        // *编写一个RPG小游戏
        // 控制英雄在游戏内走动
        // 每轮怪物随机方向走动一步,走后显示自己坐标，并显示对话。
        // 控制玩家一个方向走一步
        // 角色信息放在游戏角色数组中
        // 生成若3个小怪物,一个BOSS
        // 英雄如果与小怪物重合，小怪物被消灭。
        // 英雄在没有消灭所有小怪物之前，与BOSS相遇(相邻或者重合)，则英雄被消灭，Game Over
        // 英雄干掉所有小怪物后，追上BOSS(位置重合),游戏胜利。
        
        
    }
    return 0;
}
