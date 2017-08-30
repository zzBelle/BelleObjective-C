//
//  YellowView.m
//  EventHandling
//
//  Created by 十月 on 2017/8/14.
//  Copyright © 2017年 October. All rights reserved.
//

#import "YellowView.h"

@implementation YellowView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchBegan --- Yellow");
//    情景2 点击子控件，子控件和父控件都可以响应
    [super touchesBegan:touches withEvent:event];
}
/*
 点击了黄色的因为没有实现这个点击的方法所以顺着响应者链找到绿色的View ，绿色的View 实现了touch方法，便打印这个 _____touchBegan-Green
 
 */


@end
