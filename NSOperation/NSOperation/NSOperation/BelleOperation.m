//
//  BelleOperation.m
//  NSOperation
//
//  Created by 十月 on 2017/8/3.
//  Copyright © 2017年 October. All rights reserved.
//

#import "BelleOperation.h"

@implementation BelleOperation
//要执行的任务
- (void)main {
    for (int i = 0; i < 2; ++i) {
        NSLog(@"方式三 1------%@",[NSThread currentThread]);
    }
}
@end
