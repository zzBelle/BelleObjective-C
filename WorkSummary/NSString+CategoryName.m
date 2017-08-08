//
//  NSString+CategoryName.m
//  WorkSummary
//
//  Created by 十月 on 2017/8/8.
//  Copyright © 2017年 October. All rights reserved.
//

#import "NSString+CategoryName.h"
#import <objc/runtime.h>

static void *strKey = &strKey;

@implementation NSString (CategoryName)

- (void)setStr:(NSString *)str {
    objc_setAssociatedObject(self, &strKey, str, OBJC_ASSOCIATION_COPY);
}

- (NSString *)str {
    return objc_getAssociatedObject(self, &strKey);
}
/*
 在setStr:方法中使用了一个objc_setAssociatedObject的方法，这个方法有四个参数，分别是：
 1.源对象
 2.关联时用来标记是哪一个属性的key（可能添加很多属性）
 3.关联的对象
 4.一个关联策略
 
 用来标记哪一个属性的key常见的有三种写法，但是代码效果是一样的。
 1.static void *strKey = &strKey;
 2.static NSString *strKey = @"strKey";
 3.static char strKey;
 
 
 关联策略是一个枚举值
 enum { OBJC_ASSOCIATION_ASSIGN = 0, //关联对象的属性是弱引用
        OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, //关联对象的属性是强引用并且关联对象不使用原子性 
        OBJC_ASSOCIATION_COPY_NONATOMIC = 3, //关联对象的属性是copy并且关联对象不使用原子性 
        OBJC_ASSOCIATION_RETAIN = 01401, //关联对象的属性是copy并且关联对象使用原子性
        OBJC_ASSOCIATION_COPY = 01403 //关联对象的属性是copy并且关联对象使用原子性
 };
 

 */
@end
