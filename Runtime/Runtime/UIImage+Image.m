//
//  UIImage+Image.m
//  Runtime
//
//  Created by 十月 on 2017/8/8.
//  Copyright © 2017年 October. All rights reserved.
//

#import "UIImage+Image.h"
#import <objc/message.h>

@implementation UIImage (Image)
/**
    load 方法：把类加载进内存的时候调用，只会调用一次
 方法应先交换，再去调用
 */
+ (void)load {
//    1.获取imageNamed 方法地址
//      获取某个类的方法Class_getClassMethod
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    
//    2.获取ln_imageNamed方法地址
    Method ln_imageNamedMethod = class_getClassMethod(self, @selector(ln_imageNamed:));
    
//    3.交换方法地址，相当于贾环实现方式； method_exchangeImplementations 交换两个方法的实现
    method_exchangeImplementations(imageNamedMethod, ln_imageNamedMethod);
    
}

/*
 下方是不会造成死循环的 
 调用 imageNamed ==> ln_imageNamed 相当于调用 ln_imageNamed
 调用 ln_imageNamed ==> imageNamed
 */
//加载图片且判断是否加载成功
+ (UIImage *)ln_imageNamed:(NSString *)name {
    UIImage *image = [UIImage ln_imageNamed:name];
    if (image) {
        NSLog(@"Runtime 添加额外功能 -- 加载成功");
    }else{
        NSLog(@"Runtime 添加额外功能 -- 加载失败");
    }
    return image;
}
/*
    不能在分类中重写系统的方法imageNamed，因为会把系统功能覆盖掉，而且分类不能调用super
 + (UIImage *)imageNamed:(NSString *)name {}

 */

/*
 总结：我们所做的是在方法调用流程第三步的时候，交换两个方法地址指向。而且我们改变指向要在系统方法imageNamed:方法前调用，所以将代码写在分类load方法里。最后当运行的时候系统给的方法就会去找我们的方法的实现。
 */
@end
