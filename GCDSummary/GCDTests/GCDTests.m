//
//  GCDTests.m
//  GCDTests
//
//  Created by zhangwei on 2018/1/29.
//  Copyright © 2018年 zhangwei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCD.h"

@interface GCDTests : XCTestCase

@end

@implementation GCDTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_gcd_set_queue_priority {
    [GCD gcd_set_queue_priority];
}

- (void)test_gcd_group_notify {
    [GCD gcd_group_notify];
}

- (void)test_gcd_barrier {
    [GCD gcd_barrier];
}

- (void)test_gcd_group_wait {
    [GCD gcd_group_wait];
}

- (void)test_gcd_block_wait {
    [GCD gcd_block_wait];
}

- (void)test_gcd_semaphore {
    [GCD gcd_semaphore];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
