//
//  Movie.m
//  Runtime
//
//  Created by 十月 on 2017/8/10.
//  Copyright © 2017年 October. All rights reserved.
//

#import "Movie.h"
#import <objc/runtime.h>

#define encodeRuntime(A) \
\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [self valueForKey:key];\
[aCoder encodeObject:value forKey:key];\
}\
free(ivars);\
\

#define initCoderRuntime(A) \
\
if (self = [super init]) {\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [aDecoder decodeObjectForKey:key];\
[self setValue:value forKey:key];\
}\
free(ivars);\
}\
return self;\
\

@implementation Movie

/*正常写法
 但是有很多的时候就会出现重复大量的代码
 使用Runtime可以简化下列方法

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_movidId forKey:@"id"];
    [aCoder encodeObject:_movidName forKey:@"name"];
    [aCoder encodeObject:_pic_url forKey:@"url"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.movidId = [aDecoder decodeObjectForKey:@"id"];
        self.movidName = [aDecoder decodeObjectForKey:@"name"];
        self.pic_url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}
 
 */
/*
- (void)encodeWithCoder:(NSCoder *)aCoder {
 //使用Runtime的写法

    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Movie class], &count);
    for (int i = 0; i < count; i++) {
//      取出i位置对应的成员变量
        Ivar ivar = ivars[i];
//      查看成员变量
        const char *name = ivar_getName(ivar);
//      归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([Movie class], &count);
        for (int i = 0;i < count ; i++) {
//            取出对应i位置的成员变量
            Ivar ivar = ivars[i];
//            查看成员变量
            const char *name = ivar_getName(ivar);
//            归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
//            设置到成员变量身上
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
*/


//优化写法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    encodeRuntime(Movie);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    initCoderRuntime(Movie);
}

/*
 总结 ：上边是encodeWithCoder 和initWithCoder 这个方法抽成宏，可以将两个宏单独放到文件里边，需要进行数据持久化模型都可以使用这两个宏
 */


/*-----------------------黑魔法 method swizzling---------------------------*/
/*
 简单说就是进行方法交换
 在Objective-C中调用一个方法，其实是向一个对象发送消息，查找消息的唯一依据是selector 的名字。利用Objective-C的动态特性，可以实现运行时偷换selector对应的方法实现，达到给方法挂钩的目的
 
 每个类都有一个方法列表，存放着方法的名字和方法实现的映射关系，selector的本质就是方法名，IMP有点类似函数指针，指向具体的Method实现，通过selector就可以找到对应的IMP。
 
 交换方法的几种实现方式
    利用method_exchangeImplementations交换两个方法的实现
    利用class_replaceMethod替换方法的实现
    利用method_setImplementation来直接设置某个方法的IMP
 
 */
@end
