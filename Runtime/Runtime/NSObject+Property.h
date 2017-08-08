//
//  NSObject+Property.h
//  Runtime
//
//  Created by 十月 on 2017/8/8.
//  Copyright © 2017年 October. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)
//@property分类：只会生成get set方法声明，不会生成实现，也不回生成下划线成员变量。
@property NSString *name;
@property NSString *height;
@end
