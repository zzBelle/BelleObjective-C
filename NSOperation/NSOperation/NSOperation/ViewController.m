//
//  ViewController.m
//  NSOperation
//
//  Created by 十月 on 2017/8/3.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"
#import "BelleOperation.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    方式一
    //    [self operationCaseOne];
    //    方式二
    //    [self operationCaseTwo];
    //    方式三
//        [self operationCaseThree];
    
//    [self addOperationToQueue];
    [self operationQueue];
    
}
/*
 NSOperation 简介
 NSOperation是苹果公司提供的一套多线程解决方案。实际上是NSOperation基于GCD更高的一层封装。
 优点：比GCD更简单易用、代码可读性高
 NSOperation需要配合NSOperationQueue来实现多线程。
 默认情况下：NSOperation单独使用时系统同步操作，没有开启新线程的能力。 只有配合NSOperationQueue才能实现异步执行。
 
 NSOperation相当于GCD的任务，NSOperationQueue相当于GCD中的队列。NSOperation实现多线程分为三步：
 1.创建任务 ：首先将需要执行的操作封装到一个NSOperation对象中。
 2.创建队列 ：创建NSOperationQueue对象
 3.将任务加入到队列中 ： 然后将NSOperation对象添加到NSOperationQueue中。
 最后，系统会自动将NSOperationQueue中的NSOperation取出来，在新的线程中执行操作。
*/
/*
 NSOperation 和 NSOperationQueue 的使用
 1.创建任务
 NSOperation是一个抽象类，不能封装任务。只能使用它的子类来封装任务。有3种封装方式来封装任务。
 （1）使用子类NSInvocationOperation   （方式1）
 （2）使用子类NSBlockOperation        （方式2）
 （3）定义继承自NSOperation的子类，通过实现内部相应的方法来封装任务。 （方式3）
 在不使用NSOperationQueue，单独使用NSOperation的情况下系统同步执行操作。以下任务的三种创建方式。

 */


//不使用NSOperationQueue的情况下
//--------方式1
- (void)operationCaseOne {
//  1. 创建NSInvocationOperation 对象
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
//   2.调用start方法开始执行操作
    [operation start];
    
}
- (void)run {
    NSLog(@"方式一NSInvocationOperation -----%@",[NSThread currentThread]);
}

//--------方式2
- (void)operationCaseTwo {
    NSBlockOperation *operationBlock = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"方式二 NSBlockOperation -----%@",[NSThread currentThread]);
    }];
    
    [operationBlock start];
}
/*
 方式一和方式二 结果：  在主线程执行操作，并没有开启新线程
 
 但是，NSBlockOperation 还提供了一个方法 addExecutionBlock: ，通过 addExecutionBlock: 就可以为NSBlockOpera添加额外额操作，这些额外的操作就会在其他线程并发执行。
 
 */
- (void)blockOperation {
    
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        //在主线程
        NSLog(@"1------%@",[NSThread currentThread]);
        
    }];
    //添加额外的任务 （在子线程执行）
    [operationB addExecutionBlock:^{
        NSLog(@"2------%@",[NSThread currentThread]);
    }];
    
    [operationB addExecutionBlock:^{
        NSLog(@"3------%@",[NSThread currentThread]);

    }];
    [operationB addExecutionBlock:^{
        NSLog(@"4------%@",[NSThread currentThread]);
    }];
    [operationB start];
    
/*
 总结：blockOperationWithBlock:方法中的操作是在主线程中执行的，而addExecutionBlock: 方法中的操作是在其他线程中执行的。
 
 */
}

//---------方式三 定义继承自NSOperation的子类
/*
 先定义一个继承自NSOperation的子类，重写main方法 然后使用的时候导入头文件以此为例导入头文件BelleOperation.h
 */
- (void)operationCaseThree {
    BelleOperation *belleOp = [[BelleOperation alloc] init];
    [belleOp start];

// 总结：在没有使用NSOperationQueue、单独使用自定义子类的情况下，是在主线程执行操作，并没有开启新的线程。
}

//2.创建队列
//创建NSOperationQueue的情况下
/*
 和GCD的并发队列和串行队列不同的是：NSOperationQueue一共有两种队列：主队列 、其他队列。
 其中其他队列包含了串行、并发功能。
 */

- (void)createNSOperationQueue {
    //（1）主队列
    //凡是添加到主队列的任务，都会放到主线程中执行
    NSOperationQueue *queueMain = [NSOperationQueue mainQueue];
    
//    (2)其他队列（非主队列）
//    添加到这种队列的任务，就会自动放到子线程中执行 同时包含了：串行、并发功能
    NSOperationQueue *queueOther = [[NSOperationQueue alloc] init];
    NSLog(@"%@  %@",queueMain,queueOther);
}
//    将任务加入到队列中
/*
 NSOperation需要配合NSOperationQueue来实现多线程 需要将创建好的任务加入到队列中。总共有两种方法。
 
 方法一   - (void)addOperation:(NSOperation *)op;
 方法二   - (void)addOperationWithBlock:(void (^)(void))block;

*/
//1.需要先创建任务，再将创建好的任务加入到创建好的队列中。   - (void)addOperation:(NSOperation *)op;

- (void)addOperationToQueue {
//1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//2.创建操作
//   创建NSInvocationOperation
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(kRun) object:nil];
//    创建NSBlockOperation
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------------%@",[NSThread currentThread]);
        }
    }];
    
//    3.添加操作到队列中：
    [queue addOperation:op1]; //[op1 start];
    [queue addOperation:op2]; //[op2 start];
}
- (void)kRun {
    for (int i = 0; i < 2; ++i) {
        NSLog(@"2------%@",[NSThread currentThread]);
    }
}
/*
 总结：NSInvocationOperation 和NSOperationQueue结合后能够开启新线程，并进行并发执行。    NSBlockOperation 和NSOperationQueue也能开启新线程，进行并发执行。
 
 */

//方法二
/*
    无需创建任务，在block中添加任务，直接将任务block添加到队列中。
*/
- (void)addOperationWithBlockToQueue {
//1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    2.添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"------%@",[NSThread currentThread]);
        }
    }];
    
/*  
 总结：
    addOperationWithBlock: 和 NSOperationQueue 能够开启新线程，进行并发执行
 */
}

//3.控制并发执行和串行的关键
/*
    NSOperationQueue创建的其他队列同事具备串行、并发功能 。 maxConcurrentOperationCount叫做最大并发数。
    
    最大并发数maxConcurrentOperationCount 默认情况下是-1 表示不进行限制，默认为并发执行。
    当maxConcurrentOperationCount为1时，进行串行执行。
    当maxConcurrentOperationCount大于1时，进行并发执行，这个系数不能超过系统限制，及时设置了一个很大的值，系统也会自行调整。
 
 */
- (void)operationQueue {
//创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    设置最大并发操作数
    queue.maxConcurrentOperationCount = 2;
//    queue.maxConcurrentOperationCount = 1;//就变成了串行队列
    [queue addOperationWithBlock:^{
        NSLog(@"1---------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"2---------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"3--------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];

    }];
    [queue addOperationWithBlock:^{
        NSLog(@"4--------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];

    }];
    [queue addOperationWithBlock:^{
        NSLog(@"5--------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"6--------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
/*
    总结：
 当最大并发数为1时，任务是按照顺序串行执行的。党最大并发数为2的时候，任务是并发执行的。而且开启线程数量是有系统决定的，不需要我们来管理。
 
 */
}

//4.操作依赖
//NSOperation 和NSOperationQueue最吸引人的是它能添加操作之间的依赖关系。
//比如说A、B两个操作，执行完A，B才能执行，那么就要让B依赖于A 如下
- (void)addDependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1------%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-------%@",[NSThread currentThread]);
    }];
    [op2 addDependency:op1];//让op2依赖于op1 先执行op1，在执行op2
    [queue addOperation:op1];
    [queue addOperation:op2];
//    结果是op2依赖于op1 就是先执行op1 在执行op2
}

//5.一些其他的方法
/*
 - (void)cancel; NSOperation提供的方法， 可以取消单个操作
 - (void)cancelAllOperations; NSOperationQueue 提供的方法，可以取消队里的所有操作。
 - (void)setSuspended:(BOOL)b;可设置任务的暂停和恢复，YES代表暂停队列，NO代表恢复队列。
 - (void)isSuspended;判断暂停状态。
 
 注意：
 这里的暂停和取消并不代表可以将当前的操作立即取消，而是当当前的操作执行完毕以后不再执行新的操作。
 
 暂停和取消的区别在于：暂停操作之后还可以恢复操作，继续向下执行；而取消操作之后，所有的操作就清空了，无法再接着执行剩下的操作。

 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
