//
//  MyObj.m
//  Copy
//
//  Created by 十月 on 2017/8/15.
//  Copyright © 2017年 October. All rights reserved.
//

#import "MyObj.h"


@implementation MyObj
//copy 构造
-(id)copyWithZone:(NSZone *)zone {
    MyObj *copy = [[[self class] allocWithZone:zone] init];
    copy->_name = [_name copy];
    copy->_imutableStr = [_imutableStr copy];
    copy->_age = _age;
    return copy;
}

////mutableCopy构造
//-(id)mutableCopyWithZone:(NSZone *)zone {
//    MyObj *copy = NSCopyObject(self, 0, zone);
//    copy->_name = [_name mutableCopy];
//    copy->_age = _age;
//    return copy;
//}
@end
