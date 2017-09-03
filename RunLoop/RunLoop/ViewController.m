//
//  ViewController.m
//  RunLoop
//
//  Created by 十月 on 2017/9/3.
//  Copyright © 2017年 Belle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}
    
- (IBAction)buttonClick:(id)sender {
    NSLog(@"btnClick---------");
//    属于事件源 Source0处理
}
/*
 
 RunLoop介绍
 运行循环
 基本作用：
 1.保持程序的基本运行
 2.处理app中的各种事件 （比如触摸事件、定时器事件、selector事件）
 3.节省CPU资源 提高程序性能 有事做事，没有事休息
 
 一个RunLoop 可以处理Timer 、source、
 
 在Core Foundation中 关于RunLoop有5种模式
 
 1.CFRunLoopRef
 2.CFRunLoopMode
    常用的 1>NSDefaultRunLoopMode(主线程下的mode ，为默认mode)
          2>UITrackingRunLoopMode(SrollerView的滑动的mode 保证界面滑动的不受别的mode的影响)
          3>NSRunLoopCommonModes 占位mode
 3.CFRunLoopSourceRef（事件源）
    按照函数调用栈分类Source0 和Source1
    Source0:非基于Port 
    Source1:基于Port（端口）,通过内核和其他线程通信，接收分发系统事件
 
 4.CFRunLoopTimerRef
 5.CFRunLoopObserverRef（观察监听RunLoop的状态改变）
 
 */
    
//    比较纯净的Timer
- (void)createPureTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
//    定时器只运行在NSDefaultRunLoopMode 下，一但RunLoop进入其他的模式下，这个定时器就停止工作
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
//   一个RunLoop只能运行一种模式 标记为NSRunLoopCommonModes模式下可以 NSDefaultRunLoopMode和 UITrackingRunLoopMode 都可以运行但是只能运行一种模式
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];


}
    
    
//可以不需要手动添加到RunLoop中 默认已添加
- (void)crateTimer {

    //    使用这种方式创建的RunLoop 默认情况下已经添加到当前的RunLoop中并且模式是 NSDefaultRunLoopMode中
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    //    修改模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)run {
    NSLog(@"________run");

}
    
/*
 
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
 kCFRunLoopEntry = (1UL << 0), 1
 kCFRunLoopBeforeTimers = (1UL << 1), 2
 kCFRunLoopBeforeSources = (1UL << 2), 4
 kCFRunLoopBeforeWaiting = (1UL << 5), 32 睡眠之前
 kCFRunLoopAfterWaiting = (1UL << 6), 64 唤醒
 kCFRunLoopExit = (1UL << 7), 128
 kCFRunLoopAllActivities = 0x0FFFFFFFU
 };

 */
//   添加Observe监听RunLoop的改变
- (void)addObserverStatus {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        kCFRunLoopAllActivities 所有的状态 可以根据需要改变
        NSLog(@"监听RunLoop状态的改变------%lu",activity);
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
//    ARC下创建的OC对象可以不用管理内存 但是CFRunLoopObserverRef 是C语言
    
//    释放Observe
    CFRelease(observer);
/*
 CF的内存管理
 1.凡是带有Create、Copy、Retain等字眼的函数都需要release，
 2.release函数:CFRelease(对象)
 
 */
    

}
    
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//图片在NSDefaultRunLoopMode 模式下显示
    [self.image performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"bgImage"] afterDelay:3.0 inModes:@[NSDefaultRunLoopMode]];
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
