//
//  def.h
//  2048Demo
//
//  Created by student on 16/3/21.
//  Copyright © 2016年 马千里. All rights reserved.
//
/*
 
 Build Settings中设置
 // 头文件
 Precompile Prefix Header -> YES
 Prefix Header -> 文件的路径
 绝对路径: /Users/niit/workspace/2048/2048/def.h
 相对路径: $(SRCROOT)/2048/def.h
 
 $(SRCROOT) 项目目录
 
 
 所有页面:
 1. 第一次进入的新手导航页
 2. 游戏页
 3. 菜单页
 4. 游戏结果页
 /Users/niit/workspace/2048/2048/def.h
 游戏页制作流程:
 
 第一步:
 1）上方按钮等
 2) 画大底板
 3) 画每个小格子 4*4
 
 第二步:
 点击随机产生2个新的格子(后面移动做好后,改为每次移动之后产生新格子)
 (需要考虑使用必要的容器保存相关数据)
 
 第三步 移动 一个方向(向左)
 1) 添加手势
 2）格子往某个手势方向移动
 
 第四步 合并,一个方向
 1) 合并
 
 第五步 所有方向
 */
#ifndef def_h
#define def_h

//定义颜色
#define kRGB(x,y,z) [UIColor colorWithRed:x/100.0 green:y/100.0 blue:z/100.0 alpha:1]
#define kRGBBakcgroundColor kRGB(30,30,30)
#define kRGBBoxColor  kRGB(73,68,63)
#define kRGBCellBackColor kRGB(80,75,71)
#define k2048CellColor kRGB(91,80,37)
#define k1024CellColor kRGB(190,178,165)
#define k512CellColor kRGB(190,178,165)
#define k256CellColor kRGB(190,178,165)
#define k128CellColor kRGB(190,178,165)
#define k64CellColor kRGB(190,178,165)
#define k32CellColor kRGB(190,178,165)
#define k16CellColor kRGB(96,58,39)
#define k8CellColor kRGB(95,69,47)
#define k4CellColor kRGB(90,89,79)
#define k2CellColor kRGB(94,90,86)
//每行格子数量
#define N 4
//格子宽高
#define kCellWidth 65
//格子间隔
#define kCellPadding 5

// 盒子外围间隔
#define kBoxPadding 5

// 盒子的圆角
#define kBoxCornerRadius 5
// 单元格的圆角
#define kCellCornerRadius 3

#endif /* def_h */

























