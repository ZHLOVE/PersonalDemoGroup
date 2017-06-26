//
//  main.m
//  ExceptionDemo
//
//  Created by qiang on 16/1/26.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestException.h"

#import "TestLinkError.h"

//void func2()
//{
//    printf("1 %s",__func__);
//}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        TestException *t = [[TestException alloc] init];
        [t test];
        
//        func1();
        
    }
    return 0;
}

// 链接错误1:
//Ld /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug/ExceptionDemo normal x86_64
//cd /Users/qiang/整理/Objective-C-Example/ExceptionDemo
//export MACOSX_DEPLOYMENT_TARGET=10.11
///Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -L/Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug -F/Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug -filelist /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/ExceptionDemo.LinkFileList -mmacosx-version-min=10.11 -fobjc-arc -fobjc-link-runtime -Xlinker -dependency_info -Xlinker /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/ExceptionDemo_dependency_info.dat -o /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug/ExceptionDemo
//
//Undefined symbols for architecture x86_64:
//"_func1", referenced from:
//_main in main.o
//ld: symbol(s) not found for architecture x86_64
//clang: error: linker command failed with exit code 1 (use -v to see invocation)

// 原因:
//main.m中调用了func1函数,但函数没有具体的定义.


// 链接错误2:
//Ld /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug/ExceptionDemo normal x86_64
//cd /Users/qiang/整理/Objective-C-Example/ExceptionDemo
//export MACOSX_DEPLOYMENT_TARGET=10.11
///Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -L/Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug -F/Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug -filelist /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/ExceptionDemo.LinkFileList -mmacosx-version-min=10.11 -fobjc-arc -fobjc-link-runtime -Xlinker -dependency_info -Xlinker /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/ExceptionDemo_dependency_info.dat -o /Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Products/Debug/ExceptionDemo
//
//duplicate symbol _func2 in:
///Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/main.o
///Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/TestLinkError.o
//ld: 1 duplicate symbol for architecture x86_64
//clang: error: linker command failed with exit code 1 (use -v to see invocation)

// 原因:
// func2在main.m和TestLinkError.m中重复定义.
