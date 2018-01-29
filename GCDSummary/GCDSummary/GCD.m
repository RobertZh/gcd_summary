//
//  GCD.m
//  GCDSummary
//
//  Created by zhangwei on 2018/1/29.
//  Copyright © 2018年 zhangwei. All rights reserved.
//

#import "GCD.h"

@implementation GCD

#pragma mark - 设置优先级来实现不同队伍的同步
+ (void)gcd_set_queue_priority {
    // 1. 基于不同队列（Queue）的优先级控制实现同步
    dispatch_queue_t my_queue = dispatch_queue_create("com.gcd.gcd_set_queue_priority", DISPATCH_CURRENT_QUEUE_LABEL);
    dispatch_queue_t low_priority_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_set_target_queue(my_queue, low_priority_queue);
    dispatch_async(my_queue, ^{
        NSLog(@"我的优先级低，所以后调用。");
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"我的优先级高，所以先调用。");
    });
}
#pragma mark - 同一队列不同block控制
+ (void)gcd_barrier {
    // 要手动创建一个queue才能奏效
    dispatch_queue_t my_queue = dispatch_queue_create("com.gcd.barrier", DISPATCH_CURRENT_QUEUE_LABEL);
    
    dispatch_async(my_queue, ^{
        NSLog(@"task1 starts to execute");
        sleep(2);
        NSLog(@"task1 has executed");
        NSLog(@"#################### just for separating ####################");
    });
    dispatch_barrier_async(my_queue, ^{
        NSLog(@"task2 IN BARRIER BLOCK starts to execute");
        sleep(1);
        NSLog(@"task2 IN BARRIER BLOCK has executed");
        NSLog(@"#################### just for separating ####################");
    });
    
    dispatch_async(my_queue, ^{
        NSLog(@"task3 starts to execute");
        sleep(3);
        NSLog(@"task3 has executed");
        NSLog(@"#################### just for separating ####################");
    });
}

#pragma mark - 同一队列统一block控制
+ (void)gcd_group_notify {
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程任务1开始执行");
        sleep(1);
        NSLog(@"子线程任务1执行完毕");
        ////// 如果子线程中还有其他手动创建的队伍，需要用到dispatch_group_enter和dispatch_group_leave
        dispatch_queue_t my_queue = dispatch_queue_create("com.gcd.gcd_wait_notify_group", DISPATCH_CURRENT_QUEUE_LABEL);
        dispatch_group_enter(group);
        dispatch_async(my_queue, ^{
            NSLog(@"子线程任务1中还有子任务  ---- 开始");
            sleep(2);
            NSLog(@"子线程任务1中还有子任务  ---- 结束");
            dispatch_group_leave(group);
        });
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程任务2开始执行");
        sleep(1);
        NSLog(@"子线程任务2执行完毕");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程任务3开始执行");
        sleep(1);
        NSLog(@"子线程任务3执行完毕");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有子线程任务结束后，回到主线程操作");
    });
}


+ (int)gcd_group_wait {
    // ‼ 这个函数可以在当前线程等待其他线程结束后进行return，如果在notify的block里就不可以进行return了。
    __block int returned_value = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程任务1开始执行");
        sleep(1);
        returned_value += 10;
        NSLog(@"子线程任务1执行完毕");
        dispatch_queue_t my_queue = dispatch_queue_create("com.gcd.gcd_wait_notify_group", DISPATCH_CURRENT_QUEUE_LABEL);
        dispatch_group_enter(group);
        dispatch_async(my_queue, ^{
            NSLog(@"子线程任务1中还有子任务  ---- 开始");
            sleep(2);
            returned_value += 10;
            NSLog(@"子线程任务1中还有子任务  ---- 结束");
            dispatch_group_leave(group);
        });
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程任务2开始执行");
        sleep(1);
        returned_value += 10;
        NSLog(@"子线程任务2执行完毕");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程任务3开始执行");
        sleep(1);
        returned_value += 10;
        NSLog(@"子线程任务3执行完毕");
    });
    // 返回一个long型，这个有讲究，细看文档
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"所有子线程任务执行完毕！开始返回数据");
    return returned_value;
}

+ (void)gcd_block_wait { // 这个用得比较少
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"自定义的block开始执行");
        sleep(5);
        NSLog(@"自定义的block结束执行");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), block);
    // 和dispatch_group_wait一样，细看文档
    dispatch_block_wait(block, DISPATCH_TIME_FOREVER);
    NSLog(@"🤩🤩🤩🤩🤩🤩🤩🤩🤩🤩");
}

#pragma mark - 基于线程资源控制
+ (void)gcd_semaphore {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1); // 在同一时间只能一个线程进行临界区访问
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 99999; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 加锁
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            //////////////////////////// 临界区--开始 ////////////////////////////
            [mArray addObject:@(i)];
            //////////////////////////// 临界区--结束 ////////////////////////////
            // 解锁
            dispatch_semaphore_signal(semaphore);
        });
    }
}

@end
