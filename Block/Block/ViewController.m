//
//  ViewController.m
//  Block
//
//  Created by 十月 on 2017/8/15.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//测试系统的block 能否造成循环引用
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%@",self.view);
    }];

//    使用通知的时候调用系统的block ，在block中使用self就会造成循环引用
    
}
/*
 @synthesize 合成实例变量的规则是什么?假如 property 名为 foo,存在一个名为_foo 的实例变量,那么还会自动合成新变量么?
不会再自动合成员变量了。
 
 @synthesize 合成成员变量的规则，有以下几点
 1.如果指定了成员变量的名称，会生成一个指定的名称的成员变量如果这个成员变量已经存在了就不会再生成了。
 2.如果指定@synthesize  foo ；就会生成一个名称为foo 的成员变量，也就是说：会自动生成一个属性名相同的成员变量。 如果是@synthesize foo = _foo；就不会生成成员变量了。
*/

/*
 @synthesize 有哪些使用场景
 1.重写了getter 和 setter
 2.重写了 只读属性的getter
 3.使用了@dynamic 时
 
 在@protocol 中定义的所有属性在category中定义的所有属性重载的属性，当你在紫烈中重载了父类中的属性，必须使用@synthesize 来手动合成ivar。
 
 当你手动重写了setter和getter时，系统就不会生成ivar 这个时候要手动创建ivar
 
 */
/*
 weak 只可以修饰对象 如果修饰基本数据类型会报错
 assign 可以修饰对象 和基本数据类型 当需要修饰对象类型时，MRC使用unsafe_unretained 。但是unsafe_unretained 也可能产生野指针 
 
 
 weak 不会产生野指针 因为weak 修饰的对象释放以后，指针会自动置为nil 之后在向该对象发送消息也不会崩溃。weak 是安全的
 
 assign 修饰对象，会产生野指针问题。如果修饰基本数据类型则是安全的。 修饰的对象释放后，指针不会自动置为空。向该对象发送消息会崩溃
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
