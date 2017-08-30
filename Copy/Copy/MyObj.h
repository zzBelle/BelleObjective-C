//
//  MyObj.h
//  Copy
//
//  Created by 十月 on 2017/8/15.
//  Copyright © 2017年 October. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObj : NSObject<NSCopying,NSMutableCopying>{
    NSMutableString *_name;
    NSString *_imutableStr;
    int _age;

}
@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSString *imutableStr;
@property (nonatomic) int age;
@end
