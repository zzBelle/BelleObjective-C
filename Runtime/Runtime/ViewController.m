//
//  ViewController.m
//  Runtime
//
//  Created by 十月 on 2017/8/8.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Image.h"


#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 Runtime
 
 Runtime是基于C的，他为C添加了面向对象的特性。
 简称：运行时，是一套纯C（C和汇编写的）API。 OC就是运行时机制，也就是运行时候的一些机制，主要的是 消息机制。
 
 对于C语言，函数的调用在编译的时候会决定调用哪个函数。
 对于OC函数的调用成为消息发送，属于动态调用过程。在编译的时候并不能决定真正调用哪个函数，只有在真的运行的时候才会根据函数的名称找到对应的函数来调用。 C语言调用未实现的函数就会报错。
 
Runtime消息机制
  我们写的OC代码，在运行的时候也是转换成了Runtime方式运行的。任何方式调用本质:就是发送一个消息（用Runtime发消息，OC底层实现通过Runtime实现）。
 消息机制原理：对象根据方法编号SEL去映射表查找对应的方法实现。
 每一个OC方法，底层必有一个与之对应的Runtime方法。
 
 */

/*
Person *p = [Person alloc];
 底层的实际写法
Person *p = objc_msgSend(objc_getClass("Person"),sel_registerName("alloc"));

 p = [p init];
 p = objc_msgSend(p, sel_registerName("init"));

 调用对象方法（本质：让对象发送消息）
 [p eat];


 本质：让类对象发送消息
objc_msgSend(p, @selector(eat));
objc_msgSend([Person class], @selector(run:),20);


 也许下面这种好理解一点
// id objc = [NSObject alloc];
id objc = objc_msgSend([NSObject class], @selector(alloc));


 objc = [objc init];
objc = objc_msgSend(objc, @selector(init));

*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    交换方法
    UIImage *img = [UIImage imageNamed:@"image"];
    NSLog(@"runtime交换方法%@",img);

    
//    动态添加属性
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"123";
    NSLog(@"runtime动态添加属性name==%@",objc.name);
}

/*
 Runtime方法调用流程---【消息机制】
 问题：
    消息机制方法调用流程
    怎么调用eat方法 ，对象方法：（保存到类对象的方法列表），类方法：（保存到元类（Meta Class）中方法列表）。
        1.OC在向一个对象发送消息时，Runtime库会根据对象的isa 指针找到该对象对应的类或者其父类中查找方法。
        2.注册方法编号（这里用方法编号的好处是，可以快速查找）。
        3.根据方法编号去查找对应方法。
        4.找到只是最终函数实现地址，根据地址去方法区调用对应的函数。
 
 一个objc对象的isa指针指向什么?有什么作用？
    每一个对象内部都有一个isa指针，这个指针指向他的真实类型，根据这个指针就能知道将来调用哪个类的方法。
 
 Runtime常见作用
        动态交换两个方法的实现
        动态添加属性
        实现字典转模型的自动转换
        发送消息
        动态添加方法
        拦截并替换方法
        实现NSCoding的自动归档和解档
 
 
 Runtime交换方法
      场景：  地上那个方框架或者系统原生方法功能不能满足我们的时候，我们可以在保持系统原有方法功能的基础上，添加额外的功能。
 需求：加载一张图片直接用[UIImage imageNamed:@"image"];是无法知道底层有没有加载成功。给系统的imageNamed添加额外功能(是否加载图片成功)；
 方法一： 继承系统的类 ，重写方法（弊端：每次使用都需要导入）
 方法二： 使用Runtime ，交换方法。参考 UIImage+Image.h 和 UIImage+Image.m
 
 实现步骤：
    1.给系统的方法添加分类
    2.自己实现一个带有扩展功能的方法
    3.交换方法，只需要交换一次。
 
 
 
 
 Runtime给分类动态添加属性  
  参看NSObject+Property.h 和NSObject+Property.m
    
 原理：给一个类声明属性，其实本质就是给这个类添加关联，并不是直接把这个值的内存空间添加到类的存储空间。
 
    应用场景：给系统的类添加一个属性的时候，可以使用Runtime动态添加属性方法
    系统给NSObject添加一个分类，我们知道在分类中是不能添加成员属性的，虽然我们用了@property，但是仅仅会生成get 和set 的方法声明，并没有带下划线的属性和方法实现 生成。但是我们可以通过Runtime就可以做到给他方法的实现。
 
 需求:给系统NSObject类动态添加一个属性name字符串。
 
 
 
Runtime字典转模型

 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
