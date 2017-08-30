//
//  ViewController.m
//  Copy
//
//  Created by 十月 on 2017/8/15.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 深浅拷贝
 retain 始终都是浅拷贝
 copy 对于可变对象是深拷贝 对于不可变对象是浅拷贝 返回不可变对象
 mutableCopy 始终是深拷贝，返回一个可变的对象
 
 
 浅拷贝（浅复制）即指针拷贝 指向同一个内存 引用计数加一
 深拷贝（深复制）即内容拷贝  创建一个新的对象以及一个新的计数器 原计数器不变
 
 
 对象的自定义拷贝
 需要遵守NSCopying和NSMutableCopying协议 并且实现copyWithZone 和MutableCopyWithZone方法
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
