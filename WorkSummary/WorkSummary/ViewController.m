//
//  ViewController.m
//  WorkSummary
//
//  Created by 十月 on 2017/8/7.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
  内存管理，堆与栈的区别 哪些在堆上，哪些在栈上
 
 内存管理的范围：
    1.只有OC对象需要进行内存管理
    2.非OC对象类型比如基本数据类型不需要进行内存管理
 
 只有OC对象才需要进行内存管理的本质原因？
 因为Objective-C 的对象在内存中是以堆的方式分配内存空间的，并且堆内存是由你释放的，就是release。
 OC对象存放于堆里边（堆内存要程序猿手动释放回收）
 非OC对象一般在栈里边（栈内存会被系统自动回收）
 堆里的内存是动态分配的，所以也就需要手动添加内存回收内存
 
 
 按分配方式
    堆是动态分配和回收内存的，没有静态分配的堆(堆对象是采用链表进行管理的，操作系统有一个记录空闲内存地址的链表，当程序收到申请时，会遍历链表，寻找第一个申请的堆节点，然后将该节点从空闲节点链表中删除，并将该节点的空间分配给程序)
 
    栈是有两种分配方式：静态分配和动态分配
        静态分配 是系统编译完成的，比如局部变量的分配
        动态分配是alloc函数进行分配的，但是栈的动态分配和堆是不同的，它的动态分配也是由系统编译器进行释放，不需要手动管理。
 
 堆与栈的区别：
 栈是先进后出（LIFO） 堆是先进先出（FIFO)
 
 
 
 哪些在堆上，哪些在栈上
 我们自己申请的变量信息一般是在堆上
 程序运行时调用的函数一般是在栈上
 
 特殊的情况
 block block是在栈上的但是在copy后就到堆上了
 */
/*
 Category与Extension区别，与继承的区别，各自的适用场景
 
一、 Category 分类
 分类就是对一个类的功能进行扩展，让这个类能够适应不同情况的需求，在一般的实际开发中，都会对系统的一些常用类进行扩展，简单来说句式一种为现有的类添加新方法的方式。
 
 利用Objective-C 的动态运行时分配机制，Category提供了一种比继承更为简洁的方法对类进行扩展，无需创建对象类的子类就能实现现有的类添加新方法，可以为任何已经存在的类添加方法，包括哪些没有源码的类。如系统的框架类等
 
 Category的作用：
 1.可以将类的实现分散到多个不同的文件或者不同的框架中，方便代码的管理。也可以对框架提供类的扩展。（没有源码，不能修改）
 2.创建对私有方法的向前引用：如果其他类中的方法未实现，在你访问其他类的私有方法时编译器报错这时使用类别，在类别中声明这些方法（不必提供方法的实现），编译器就不会在产生警告。
 3.向对象添加非正式的协议：创建一个NSObject的类别称为"创建一个非正式协议"，因为可以作为任何类的委托对象使用。
 
 
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
