//
//  ViewController.m
//  EventHandling
//
//  Created by 十月 on 2017/8/14.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"
#import "GreenView.h"
#import "RedView.h"
#import "YellowView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RedView *red = [[RedView alloc] initWithFrame:CGRectMake(10, 20, 300, 300)];
    [self.view addSubview:red];
    
    GreenView *green = [[GreenView alloc] initWithFrame:CGRectMake(20, 130, 200, 100)];
    [red addSubview:green];
    
    YellowView *yellow = [[YellowView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [green addSubview:yellow];
}

/*
 - (UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event; 什么时候调用？
 只要事件一传递给一个空间，这个方法就会调用他自己的hitTest:(CGPoint)point withEvent: 方法来寻找合适的View
 作用：
 寻找并返回最合适的View （能响应时间并且触摸点在自己身上的View）
 ❤️不管这个控件能不能处理事件，也不管触摸点在不在这个View上，事件都会传递给这个控件，随后调用hitTest:(CGPoint)point withEvent:方法。
 
 hitTest:(CGPoint)point withEvent:方法中有是否能接收事件，触摸点在不在当前控件，然后从当前遍历自己的子控件，寻找合适的View，找到合适的就返回合适的，没有就返回自己。
 
 应用如何找到最合适的控件来处理事件？有以下准则
 1.首先判断主窗口（keyWindow）自己是否能接受触摸事件
 2.触摸点是否在自己身上
 3.从后往前遍历子控件，重复前面的两个步骤（首先查找数组中最后一个元素）
 4.如果没有符合条件的子控件，那么就认为自己最合适处理
 
总结：
    触摸或者点击控件，然后这个事件会从上向下（从父控件到子控件）找到最合适的View处理，找到View后看看能不能满足条件（1.触摸点是否在自己身上 2.是否能够接受触摸事件），能就处理，不能就按照响应链向上（从子控件向父控件）传递给父控件。
 找到合适的View就会调用touches 找不到就不会调用。
 
 
 事件的传递 从父到子
 事件的响应 从子到父控件
 
 */


/*
 情景1：点击了子控件 让父控件响应
 
 可以通过两种方式实现
 1.因为hitTest:(CGPoint)point withEvent:是控件接受事件后来判断是不是最适合的View的方法，所以可以在这个方法里强制返回父控件最合适
 
 2.让谁响应重写谁的touchesBegan: withEvent:方法
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
