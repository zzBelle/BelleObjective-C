//
//  ViewController.m
//  GCD
//
//  Created by 十月 on 2017/7/28.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
//GCD
/*
 GCD 可以用于多核并行运算 会自动利用更多的CPU内核 GCD惠东管理线程的生命周期（创建线程、调度任务 销毁线程）
 GCD的核心 是  任务和队列
 
 ****任务****
 任务就是执行的操作 就是在线程中执行的那段代码  在GCD中是放在block中的 执行任务有两种方式 同步执行和异步执行 区别是时候具备开启新线程的能力
 
 同步执行（sync）：只能在当前的线程中执行任务 不具备开启新线程的能力
 
 异步执行（async）：可以在新的线程中执行任务， 具备开启新线程的能力
 
 ***队列***
 队列是一种新的线性表，采用先进先出的原则，即新任务重视被插入到队列的末尾，而读取任务真是从队列的头部开始，每读取一个任务，则是从队列中释放一个任务。在GCD中有两种队列：串行队列 和 并发队列
 
 并发队列：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
 注意：并发功能只有在异步函数下才有效
 
 串行对列：让任务一个接一个的执行（一个任务执行完毕后在执行下一个任务）
 
 使用步骤：
 1.创建一个队列（串行队列或者并发队列）
 2.将任务添加到队列中，然后系统会根据任务类型执行任务（同步执行或者异步执行）
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    /*队列的创建方法*/

////    串行队列的创建方法
//    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
////    并发队列的创建方法
//    dispatch_queue_t queueC = dispatch_queue_create("test.queueC", DISPATCH_QUEUE_CONCURRENT);
//    NSLog(@"%@   %@",queue,queueC);
// 
////     对于并发队列还可以使用dispatch_get_global_queue来创建全局并发队列.GCD默认提供了全局的并发队列，需要传入两个参数。第一个参数是队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAUIL。第二个参数暂时没有用，用0即可。
//    
//    /*任务的创建方法*/
////    同步任务创建方法
//    dispatch_sync(queue, ^{
//        NSLog(@"%@",[NSThread currentThread]);//任务代码
//    });
////    异步任务的创建方法
//    dispatch_async(queue, ^{
//        NSLog(@"%@",[NSThread currentThread]);//任务代码
//    });
    
    

//    使用GCD需要两步，有两种队列，两种任务执行方式，那么我们就有四中不同的组合方式。
/*   
    1.并发队列 + 同步执行
    2.并发队列 + 异步执行
    3.串行队列 + 同步执行
    4.串行队列 + 异步执行
 还有两种特殊的队列，是主队列，有六种不同的组合方式。
    1.主队列 + 同步执行
    2.主队列 + 异步执行
*/
    [self show];

}

/*
 队列的创建方法 可以使用dispatch_queue_create来创建，需要传入两个参数，第一个参数表示队列的唯一标识符， 第二个参数可以用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL表示串行队列，DISPATCH_QUEUE_CONCURRENT表示并发队列
 
 */

- (void)syncConCurrent {
    NSLog(@"syncConcurrent -- begin");
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent ---end");
    
    
}
//主队列 + 同步执行
- (void)syncMain {
    NSLog(@"syncMain--begin");
//    获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1----%@",[NSThread currentThread]);
            
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 2; ++i) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"syncMain---end");
/*
 主线程中执行这段代码。我们阿布任务放到了主队列中，也就是放到主线程的队列中。 而同步执行有个特点，就是对任务是立马执行的。当我们把第一个任务放进主队列中，他就会立马执行。但是主线程现在正在处理syncMain方法，所以任务需要等到syncMain执行完才能执行。而syncMain执行到第一个任务的时候，又要等第一个任务执行完才能往下执行第二个和第三个任务。
 现在就是syncMain方法和第一个任务都是在等对方执行完毕。这样大家互相等待，所以卡住了，所以我们的任务执行不了，而且syncMain--end也没有打印。
 
 
 */
    
    
//    GCD之间的通讯
    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        
//        回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2---%@",[NSThread currentThread]);
        });
    });
    

    
}
//GCD的栅栏方法
/*
 我们有时需要异步执行两组操作，第一组执行完成以后，才能开始执行第二组的操作。我们就需要一个相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，这里的操作组可以包含一个或多个任务。秩序哟啊到dispatch_barrier_async方法在两个操作组之间形成栅栏。
 
 */

- (void)barrier {
    
    dispatch_queue_t queue = dispatch_queue_create("name123", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"----1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----2----%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier 相当于是一个栅栏----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"-----4----%@",[NSThread currentThread]);
    });
}

//GCD的延时执行方法 dispatch_after
//当我们需要延迟执行一段代码的时候，需要用到GCD的延时方法dispatch_after方法。
- (void)after {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        2秒后异步执行这里的代码
        NSLog(@"run----");
    });
}

//GCD 的一次性代码（只执行一次）dispatch_once
/*
 我们在创建单例、或者有整个程序运行过程中只执行一次的代码，我们用到了GCD的dispatch_onece方法。使用dispatch_once函数能保证某段代码在程序运行过程中只被执行一次。
 
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        只执行一次的代码，这里默认是线程安全的。
    });
}


//GCD的快速迭代方法 dispach_apply
/*
 我们通常会使用for循环，但是GCD给我们提供了更快速的迭代放阿飞dispatch_apply,使我们可以同时遍历。比如说遍历0~5这6个数字，for循环的做法是每次取出一个元素逐个遍历。dispatch_apply可以同时遍历多个数字。
 
*/
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd-----%@",index,[NSThread currentThread]);
    });
}

//GCD的队列组
/*
    有时候我们会有这样的需求：分别异步执行2个耗时操作，然后当2个耗时操作都执行完毕的时候在回到主线程执行操作。这个时候我们可以用到GCD 的队列组。
 1.首先将任务放到队列中，然后将队列放入队列组中。
 2.调用队列组的dispatch_group_notify回到主线程执行操作
 */
- (void)queueGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        执行一个耗时的异步操作
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        执行一个耗时的异步操作
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        等待前面的异步操作执行完毕后，回到主线程。。。。
    });

}

- (void)show {
    NSLog(@"1");
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_notify(group, queue, ^{
        NSLog(@"2");
    });
    dispatch_group_enter(group);
    dispatch_sync(queue, ^{
        NSLog(@"3");
    });
    dispatch_group_leave(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"4");
    });
    NSLog(@"5");
}

//***************************************线程死锁
//案例一 同步遇到了串行
- (void)syncAndMainQueue {
    NSLog(@"1 任务一");
//    dispatch_sync 同步线程  dispatch_get_main_queue运行在主线程的串行队列
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2任务二");
    });
    NSLog(@"3  任务三");
/*
 执行任务1 ，接下来遇到同步线程，会那么她会进入等待，等任务2执行完毕以后，然后执行任务3.但是这个主队列，是一个特殊的串行队列，有任务来，就会添加到队尾。然后遵循先进先出FIFO的原则执行任务。那么现在任务2就会添加到任务3的后边。就会造成任务3要等到任务2执行完才会执行，但是任务2在任务3的后边，就意味着任务2要在任务3执行完成才能执行。所以进入了互相等待的局面。造成了死锁。
 结果: 1
 */
}

//案例二 同步和全局并发
- (void)syncAndGlobalQueue {
    NSLog(@"1 任务一");
dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSLog(@"2任务二");
});
    
    NSLog(@"3  任务三");
/*
 首先执行任务一，接着遇到了同步线程，程序会进入等待。等任务2执行完成以后才能继续执行任务3.从dispatch_get_global_queue可以看出，任务2被加入到全局的并发队列中，当并发队列执行完成任务2以后，返回主队列，继续执行任务3.
 
 结果为 1 2 3
 */
}

//案例三  同步异步共行
- (void)syncAndAsync {

    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1 任务一");
    dispatch_async(queue, ^{
        NSLog(@"2任务二");
        
        dispatch_sync(queue, ^{
            NSLog(@"3  任务三");
        });
        NSLog(@"4  任务四");

    });
    NSLog(@"5  任务五");
/*
 使用dispatch_queue_create函数创建了一个DISPATCH_QUEUE_SERIAL的串行队列。
 1.执行任务1;
 2.遇到异步线程，将{任务2、同步线程、任务4}添加到串行队列中。因为是异步线程，所以在主线程中的任务5不必等待异步线程中的任务完成；
 3.因为任务5不用等待，所以任务2和任务5的输出是不能确定的；
 4.任务2执行完成以后，遇到同步线程，这时，将任务3加入到串行队列；
 5.又因为任务4比任务3早加入串行队列，所以，任务3要等待任务4完成才能执行。但是任务3所在的同步线程会阻塞，所以任务4又在任务3执行完以后在执行。这又陷入了无限的等待中，造成死锁。
 
 结果为：1 5 2  （3和4死锁不输出）     或者  1 2 5 （3和4死锁不输出）
 */
    
}

//案例四 异步和同步 回到主线程
- (void)syncAndAsyncComeMain {
    NSLog(@"1 任务一");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2任务二");
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3  任务三");
        });
        NSLog(@"4  任务四");
    });
    NSLog(@"5  任务五");
/*
 这个是典型的异步加载数据，回调主线程更新UI
 
 首先，将{任务1、异步线程、任务5}加入Main Queue中，异步线程中的任务是：{任务2、同步线程、任务4}
 
 所以先执行任务1，然后将异步线程中的任务加入到global queue中，因为异步线程，所以任务5不用等待，结果就是2和5的输出顺序不一定。
 然后异步线程中的任务执行顺序。任务2执行完以后，遇到同步线程。将同步线程中的任务又回调到main queue 中，只是加入的任务3在任务5的后边。当任务3执行完了以后，没有线程阻塞，程序执行任务4.
 
 得到的结果：任务1最先执行； 2和5 顺序不一定； 4一定在3的后边；
 
 
 */
}

//案例五 典型的案例4 遇到主线程上无限循环
- (void)five {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1 任务一");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2 任务二");

        });
        NSLog(@"3 任务三");

    });
        NSLog(@"4 任务四");
        while (1) {}
    NSLog(@" 5  任务五");
/*
 main queue 主队列：{异步线程、任务4、 死循环、任务5}。
 在加入到global queue异步线程中的任务有：{任务1 、 同步线程、任务3}
 首先就是异步线程，任务4不用等待，所以结果就是任务1和任务4顺序不一定。
 任务4完成以后程序进入死循环，main queue阻塞。但是家兔到global queue的异步线程不受影响，继续执行任务1后边的同步线程。
 在同步线程中，将任务2加入到了主线程，并且任务3等待任务2完成以后才能执行。这是主线程，已经被死循环阻塞，所以任务2无法执行，当然任务3也无法执行，在死循环后的任务5也没办法执行。
 结果就是1和4 且顺序不定。
 
 */
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
