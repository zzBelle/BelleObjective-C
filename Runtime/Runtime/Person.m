//
//  Person.m
//  Runtime
//
//  Created by 十月 on 2017/8/10.
//  Copyright © 2017年 October. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

//没有返回值 一个参数
void aa(id self,SEL _cmd,NSNumber *meter) {
    NSLog(@"跑了%@",meter);
}

//任何方法都默认有两个隐式参数 self，_cmd 当前方法的编号
//只要一个对象调用了未实现的方法就会调用这个方法，进行处理
//作用:动态添加方法，处理未实现
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"run:")) {
//    动态的添加run方法
//    class给那个类添加方法
//    SEL添加那个方法，即添加方法的编号
//    IMP方法实现==>函数的入口 ==>函数名 （添加方法的函数实现 （函数地址））
//    type 方法类型（返回值+参数类型） v:void @对象->self:表示SEL->_cmd
        class_addMethod(self, sel, (IMP)aa, "v@:@");
        return YES;
        
    }
    return [super resolveClassMethod:sel];
}

@end
