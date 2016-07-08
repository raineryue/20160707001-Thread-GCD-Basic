//
//  ViewController.m
//  20160707001-Thread-GCD-Basic
//
//  Created by Rainer on 16/7/7.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

/**
 *  GCD知识点
 *  总结：
 *  1.异步函数 + 并行队列 : 可以同时开启多条线程并发执行
 *  2.同步函数 + 并行队列 : 不会开启新的线程
 *  3.异步函数 + 串行队列 : 会开启新的线程，但任务是串行的，执行完一个任务，再执行下一个任务
 *  4.同步函数 + 串行队列 : 不会开启新的线程，在当前线程中执行，任务是串行的，执行完一个任务，再执行下一个任务
 *  5.异步函数 + 主队列 : 不会开启新的线程，在当前线程中执行，任务是串行的，执行完一个任务，再执行下一个任务
 *  6.同步函数 + 主队列 :
 *  
 *  7.获取串行队列的方式
 *    (1)手动创建：dispatch_queue_t serialQueue = dispatch_queue_create("com.rainer.queue.print", DISPATCH_QUEUE_SERIAL);
 *    (2)获取全局主队列：dispatch_queue_t mainQueue = dispatch_get_main_queue();
 *  8.获取并行队列的方式
 *    (1)手动创建：dispatch_queue_t concurrentQueue = dispatch_queue_create("com.rainer.queue.print", DISPATCH_QUEUE_CONCURRENT);
 *    (2)获取全局并发队列：dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 异步函数 + 并行队列 : 可以同时开启多条线程并发执行
    [self dispatchAsyncConcurrentQueue];
    
    // 同步函数 + 并行队列 : 不会开启新的线程
//    [self dispatchSyncConcurrentQueue];
    
    // 异步函数 + 串行队列 : 会开启新的线程，但任务是串行的，执行完一个任务，再执行下一个任务
//    [self dispatchAsyncSerialQueue];
    
    // 同步函数 + 串行队列 : 不会开启新的线程，在当前线程中执行，任务是串行的，执行完一个任务，再执行下一个任务
//    [self dispatchSyncSerialQueue];
    
    // 异步函数 + 主队列 : 不会开启新的线程，在当前线程中执行，任务是串行的，执行完一个任务，再执行下一个任务
//    [self dispatchAsyncMainQueue];
    
    // 同步函数 + 主队列 :
//    [self dispatchSyncMainQueue];
}

/**
 *  同步函数 + 主队列 : 卡死
 *  这里会出现卡死的情况，一般不这么用，在主线程中不需要使用同步函数；或者同步函数一般不会使用主队列
 */
- (void)dispatchSyncMainQueue {
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@"0:=============================>当前线程为[%@].", [NSThread currentThread]);
    
    // 使用一个异步函数来执行该队列
    dispatch_sync(mainQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"1:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    // 添加多个任务到并行队列中
    dispatch_sync(mainQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"2:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    dispatch_sync(mainQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"3:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    
    NSLog(@"4:=============================>当前线程为[%@].", [NSThread currentThread]);
}

/**
 *  异步函数 + 主队列 : 只会在主线程中执行任务
 */
- (void)dispatchAsyncMainQueue {
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 使用一个异步函数来执行该队列
    dispatch_async(mainQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"1:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    // 添加多个任务到并行队列中
    dispatch_async(mainQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"2:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    dispatch_async(mainQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"3:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
}

/**
 *  同步函数 + 串行队列 : 不会开启新的线程，在当前线程中执行，任务是串行的，执行完一个任务，再执行下一个任务
 *  这里会在当前线程中串行的执行队列中的任务
 */
- (void)dispatchSyncSerialQueue {
    // 创建一个并行队列，参数：第一个参数：队列标签（名称）；第二个参数：队列类型（串行队列->DISPATCH_QUEUE_SERIAL、并行队列->DISPATCH_QUEUE_CONCURRENT）
    dispatch_queue_t serialQueue = dispatch_queue_create("com.rainer.queue.print", DISPATCH_QUEUE_SERIAL);
    // 这里传NULL也认为是主队列
//    dispatch_queue_t serialQueue = dispatch_queue_create("com.rainer.queue.print", NULL);
    
    // 使用一个异步函数来执行该队列
    dispatch_sync(serialQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"1:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    // 添加多个任务到并行队列中
    dispatch_sync(serialQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"2:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    dispatch_sync(serialQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"3:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    
    // MRC下需要自己释放
    //    dispatch_release(concurrentQueue);
}

/**
 *  异步函数 + 串行队列 : 会开启新的线程，但任务是串行的，执行完一个任务，再执行下一个任务
 *  这里只会开启一条线程，在该线程中串行的执行队列中的任务
 */
- (void)dispatchAsyncSerialQueue {
    // 创建一个并行队列，参数：第一个参数：队列标签（名称）；第二个参数：队列类型（串行队列->DISPATCH_QUEUE_SERIAL、并行队列->DISPATCH_QUEUE_CONCURRENT）
    dispatch_queue_t serialQueue = dispatch_queue_create("com.rainer.queue.print", DISPATCH_QUEUE_SERIAL);
    
    // 使用一个异步函数来执行该队列
    dispatch_async(serialQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"1:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    // 添加多个任务到并行队列中
    dispatch_async(serialQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"2:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    dispatch_async(serialQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"3:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    
    // MRC下需要自己释放
    //    dispatch_release(concurrentQueue);
}

/**
 *  同步函数 + 并行队列 : 不会开启新的线程
 *  这里只会在当前线程中按顺序执行并发队列中的任务
 */
- (void)dispatchSyncConcurrentQueue {
    // 创建一个并行队列，参数：第一个参数：队列标签（名称）；第二个参数：队列类型（串行队列->DISPATCH_QUEUE_SERIAL、并行队列->DISPATCH_QUEUE_CONCURRENT）
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.rainer.queue.print", DISPATCH_QUEUE_CONCURRENT);
    
    // 这里可以直接使用全局的并发队列,参数：第一个参数：队列的等级；第二个参数：预留参数一般传0
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 使用一个异步函数来执行该队列
    dispatch_sync(concurrentQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"1:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    // 添加多个任务到并行队列中
    dispatch_sync(concurrentQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"2:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    dispatch_sync(concurrentQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"3:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    
    // MRC下需要自己释放
    //    dispatch_release(concurrentQueue);
}

/**
 *  异步函数 + 并行队列 : 可以同时开启多条线程并发执行
 *  这里开了三条线程一起并发执行队列中的所有任务
 */
- (void)dispatchAsyncConcurrentQueue {
    // 创建一个并行队列，参数：第一个参数：队列标签（名称）；第二个参数：队列类型（串行队列->DISPATCH_QUEUE_SERIAL、并行队列->DISPATCH_QUEUE_CONCURRENT）
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.rainer.queue.print", DISPATCH_QUEUE_CONCURRENT);
    
    // 使用一个异步函数来执行该队列
    dispatch_async(concurrentQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"1:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    // 添加多个任务到并行队列中
    dispatch_async(concurrentQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"2:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    dispatch_async(concurrentQueue, ^{
        // 这里放队列里面需要执行的任务
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"3:=============================>当前线程为[%@].", [NSThread currentThread]);
        }
    });
    
    // MRC下需要自己释放
//    dispatch_release(concurrentQueue);
}

@end
