//
//  NSObject+Property.m
//  Runtime
//
//  Created by 十月 on 2017/8/8.
//  Copyright © 2017年 October. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)
- (void)setName:(NSString *)name {
/*
 objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy) 将某个值跟某个对象关联起来，将某个值存储到某个对象中
 id object 给那个对象添加属性
 void *key 属性名称
 id value 属性值
 objc_AssociationPolicy policy 保存策略
 */
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)name {
    return objc_getAssociatedObject(self, @"name");
}
/*
 总结：给属性赋值的本质，就是让属性与一个对象产生关联，所以要给NSObject的分类的name 属性赋值就是让name和NSObject产生关联，使用Runtime就可以做到这一点。
 
 */
@end
