//
//  DebugTestTests.m
//  DebugTestTests
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DebugMe.h"

@interface DebugTestTests : XCTestCase

@property (nonatomic,strong) DebugMe *debugMe;

@end

@implementation DebugTestTests

// 1. 搭建测试
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.debugMe = [[DebugMe alloc] init];
}

// 2. 拆除测试
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.debugMe = nil;
    
    [super tearDown];
}

// 具体测试的方法
- (void)testDebugMeIsFalse
{
    BOOL result = [self.debugMe isFalse];
    XCTAssertFalse(result,@"DebugMe isFalse 要返回false,但返回的不对!");// 期望得到False的结果,但是返回结果不是想要的，则为测试不通过
}

- (void)testDebugMeIsTrue
{
    BOOL result = [self.debugMe isTrue];
    XCTAssertTrue(result,@"返回应该是YES,但是结果不对");
    
}

- (void)testDebugMeHelloWorld
{
    NSString *result = [self.debugMe helloworld];
    XCTAssertEqualObjects(result,@"Hello World",@"期望得到Hellowolrd，结果不符合:结果是:%@",result);
}


//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
