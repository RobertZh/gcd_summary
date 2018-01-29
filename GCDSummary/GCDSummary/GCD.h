//
//  GCD.h
//  GCDSummary
//
//  Created by zhangwei on 2018/1/29.
//  Copyright © 2018年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCD : NSObject

+ (void)gcd_set_queue_priority;
+ (void)gcd_group_notify;
+ (void)gcd_barrier;
+ (int)gcd_group_wait;
+ (void)gcd_block_wait;
+ (void)gcd_semaphore;

@end
