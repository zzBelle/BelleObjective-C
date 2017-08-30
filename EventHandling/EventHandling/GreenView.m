//
//  GreenView.m
//  EventHandling
//
//  Created by 十月 on 2017/8/14.
//  Copyright © 2017年 October. All rights reserved.
//

#import "GreenView.h"

@implementation GreenView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_____touchBegan-Green");
}
/*
情景1-1
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self superview];
    // return nil; // 此处返回nil也可以。返回nil就相当于当前的view不是最合适的view
}
*/
@end
