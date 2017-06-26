# 静态库


##.a静态库
####1. 制作.a静态库步骤
1. 新建一个静态库项目 
  * 项目模板中选择iOS Framework & Library 
  * 选择 Cocoa Touch Static Library 模板
  * 输入静态库项目属性:
    * Product Name: MyLib
    * Organization Name:NIIT
    * Organization identifier:com.niit
  * 点击next,然后选择存放路径点击create
2. 项目默认新建了一个MyLib的类,编辑这个类
3. 再新建一个类MyTools
4. 编辑项目的Build Phases 中的Copy Files选项,添加Mytools.h
5. 编译两次(模拟器一次，Generic iOS Device一次)
6. 右键点击项目中生成的libMyLib.a, show In Finder 查看有没有生成2个版本的libMyLib.a


MyLib.h
```objc
#import <Foundation/Foundation.h>

@interface MyLib : NSObject

- (int)addA:(int)a andB:(int)b;

@end
```

MyLib.m
```objc
#import "MyLib.h"

@implementation MyLib

- (int)addA:(int)a andB:(int)b
{
    return a+b;
}

@end
```

MyTools.h
```
#import <Foundation/Foundation.h>

@interface MyTools : NSObject

+ (NSString *)showInfo;

@end

```
MyTools.m
```
#import "MyTools.h"

@implementation MyTools

+ (NSString *)showInfo
{
    return @"😄haha";
}
@end
```

####2. 测试制作的.a静态库

##framework静态库
// 资料参考网址: http://www.cocoachina.com/ios/20141126/10322.html
####1 制作framework静态库

Aggregate脚本:
```
# Sets the target folders and the final framework product.
# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME
# 例如: FMK_NAME = "MyFramework"
FMK_NAME=${PROJECT_NAME}
# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework
# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean build
# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r "${WRK_DIR}"
open "${INSTALL_DIR}"
```
// 查看支持的cpu
// lipo -info ./QiangFramework.framework/QiangFramework

####2 测试制作的framework静态库
// 步骤:
// 1. 将QiangFramework.framework拉入项目
// 2. 项目设置 General 中 Embedded Library 中添加 QiangFramework.framework
// 3. 引入头文件 #import <QiangFramework/QiangFramework.h>