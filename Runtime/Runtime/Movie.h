//
//  Movie.h
//  Runtime
//
//  Created by 十月 on 2017/8/10.
//  Copyright © 2017年 October. All rights reserved.
//

#import <Foundation/Foundation.h>

// 如果想要当前的类可以实现归档和反归档 需要遵守一个协议NSCoding
@interface Movie : NSObject<NSCoding>

@property (nonatomic, copy) NSString *movidId;
@property (nonatomic, copy) NSString *movidName;
@property (nonatomic, copy) NSString *pic_url;

@end
