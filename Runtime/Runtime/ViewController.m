//
//  ViewController.m
//  Runtime
//
//  Created by 十月 on 2017/8/8.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Image.h"
#import <objc/runtime.h>

#import "Person.h"

#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 Runtime
 
 Runtime是基于C的，他为C添加了面向对象的特性。
 简称：运行时，是一套纯C（C和汇编写的）API。 OC就是运行时机制，也就是运行时候的一些机制，主要的是 消息机制。
 
 对于C语言，函数的调用在编译的时候会决定调用哪个函数。
 对于OC函数的调用成为消息发送，属于动态调用过程。在编译的时候并不能决定真正调用哪个函数，只有在真的运行的时候才会根据函数的名称找到对应的函数来调用。 C语言调用未实现的函数就会报错。
 
Runtime消息机制
  我们写的OC代码，在运行的时候也是转换成了Runtime方式运行的。任何方式调用本质:就是发送一个消息（用Runtime发消息，OC底层实现通过Runtime实现）。
 消息机制原理：对象根据方法编号SEL去映射表查找对应的方法实现。
 每一个OC方法，底层必有一个与之对应的Runtime方法。
 
 */

/*
Person *p = [Person alloc];
 底层的实际写法
Person *p = objc_msgSend(objc_getClass("Person"),sel_registerName("alloc"));

 p = [p init];
 p = objc_msgSend(p, sel_registerName("init"));

 调用对象方法（本质：让对象发送消息）
 [p eat];


 本质：让类对象发送消息
objc_msgSend(p, @selector(eat));
objc_msgSend([Person class], @selector(run:),20);


 也许下面这种好理解一点
// id objc = [NSObject alloc];
id objc = objc_msgSend([NSObject class], @selector(alloc));


 objc = [objc init];
objc = objc_msgSend(objc, @selector(init));

*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    交换方法
    UIImage *img = [UIImage imageNamed:@"image"];
    NSLog(@"runtime交换方法%@",img);

    
//    动态添加属性
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"123";
    NSLog(@"runtime动态添加属性name==%@",objc.name);
    
    
//   动态添加方法
//    Person *person = [[Person alloc] init];
////    默认person没有实现run:方法 可以通过performSelector调用但是报错。 动态添加方法就不会报错
//    [person performSelector:@selector(run:) withObject:@10];
}

/*
 Runtime方法调用流程---【消息机制】
 问题：
    消息机制方法调用流程
    怎么调用eat方法 ，对象方法：（保存到类对象的方法列表），类方法：（保存到元类（Meta Class）中方法列表）。
        1.OC在向一个对象发送消息时，Runtime库会根据对象的isa 指针找到该对象对应的类或者其父类中查找方法。
        2.注册方法编号（这里用方法编号的好处是，可以快速查找）。
        3.根据方法编号去查找对应方法。
        4.找到只是最终函数实现地址，根据地址去方法区调用对应的函数。
 
 一个objc对象的isa指针指向什么?有什么作用？
    每一个对象内部都有一个isa指针，这个指针指向他的真实类型，根据这个指针就能知道将来调用哪个类的方法。
 
 Runtime常见作用
        动态交换两个方法的实现
        动态添加属性
        实现字典转模型的自动转换
        发送消息
        动态添加方法
        拦截并替换方法
        实现NSCoding的自动归档和解档
 
 
 Runtime交换方法
      场景：  地上那个方框架或者系统原生方法功能不能满足我们的时候，我们可以在保持系统原有方法功能的基础上，添加额外的功能。
 需求：加载一张图片直接用[UIImage imageNamed:@"image"];是无法知道底层有没有加载成功。给系统的imageNamed添加额外功能(是否加载图片成功)；
 方法一： 继承系统的类 ，重写方法（弊端：每次使用都需要导入）
 方法二： 使用Runtime ，交换方法。参考 UIImage+Image.h 和 UIImage+Image.m
 
 实现步骤：
    1.给系统的方法添加分类
    2.自己实现一个带有扩展功能的方法
    3.交换方法，只需要交换一次。
 
 
 
 
 Runtime给分类动态添加属性  
  参看NSObject+Property.h 和NSObject+Property.m
    
 原理：给一个类声明属性，其实本质就是给这个类添加关联，并不是直接把这个值的内存空间添加到类的存储空间。
 
    应用场景：给系统的类添加一个属性的时候，可以使用Runtime动态添加属性方法
    系统给NSObject添加一个分类，我们知道在分类中是不能添加成员属性的，虽然我们用了@property，但是仅仅会生成get 和set 的方法声明，并没有带下划线的属性和方法实现 生成。但是我们可以通过Runtime就可以做到给他方法的实现。
 
 需求:给系统NSObject类动态添加一个属性name字符串。
 
 
 
Runtime字典转模型
 字典转模型KVC实现
        KVC转模型的弊端：必须保证模型中的属性和字典中的key是一一对应。
        不一致就会调用 setValue:forUndefinedKey: 报找不到key的错。
        模型中的属性和字典的key不一一对应，系统就会调用 setValue:forUndefinedKey: 报错。
        解决方法：重写对象的  setValue:forUndefinedKey: ，把系统的方法覆盖，就能就行使用KVC，字典转模型了。
 
 字典转模型Runtime实现
        利用运行时，遍历模型中所有属性，根据模型属性名，字典中查找key，取出对应的值，给模型的属性赋值。
 考虑：
    1.当字典的key和模型的属性匹配不上
    2.模型中嵌套模型（模型属性是另外一个模型对象）
    3.数组中装着模型（模型的属性是一个数组，数组中是一个一个模型对象）
 注释：根据上面的三种情况，显示字典的key和模型的属性不对应的情况。不对应有两种，一种是字典的键值大于模型属性数量这时候我们不哟啊任何处理，因为Runtime是先遍历模型所有属性，再去字典中根据属性名找到对应进行赋值，多余的兼职对也当然不会去看；另外一种是模型属性数量大于字典的键值对，这时候属于属性没有对应值会被赋值为nil，就会导致crash，我们需要加一个判断即可。
 
    步骤：提供一个NSObject分类，专门字典转模型，以后所有模型都可以通过这个分类实现字典转模型。
 
 MJExtension字典转模型的实现
    底层也是对Runtime的封装，才可以吧一个模型中所有属性遍历粗来。
 

 字典转模型  Runtime的实现方式
    示例使考虑了是那种情况包含在内的转换示例。
 参考image_one.png
 
 1.Runtime字典转模型-->字典的key和模型的属性不匹配【模型属性数量大于字典键值对数量】，这种情况处理如下：
 
 */
+ (instancetype)modelWithDic:(NSDictionary *)dict {
    
//    创建对应的对象
    id objc = [[self alloc] init];
//    利用Runtime给对象中的属性赋值
    unsigned int count = 0;
//    获取类中所有的成员变量
    Ivar *ivarlList = class_copyIvarList(self, &count);
    
//    遍历所有成员变量
    for (int i = 0; i < count; i++) {
//根据角标，从数组取出对应的成员变量
        Ivar ivar = ivarlList[i];
//        获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        处理成员变量名->字典中的key（去掉_，送第一个角标开始截取）
        NSString *key = [ivarName substringFromIndex:1];
//        根据成员属性名去字典中查找对应的Value
        id value = dict[key];
//        如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil 而报错（could not set nil as the value for key age）
        if (value) {
            //给模型中属性赋值
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}
/*
 总结：获取模型类中的所有属性名，是采用class_copyIvarList先获取成员变量（下划线开头），然后在处理成员变量名->字典中的key(去掉_,从第一个角标开始截取)得到属性名。
 原因：Ivar：成员变量，一下划线开头，Property属性
 获取类里边的属性class_copyPropertyList
 获取类中的所有成员变量class_copyIvarList
 {
    int _a;
 }
 @property (nonatomic,assign) NSInterger attitudes_count; //属性
 这里有成员变量 就不会漏掉属性； 如果有属性，可能会漏掉成员变量
 */
+ (instancetype)modelWithDic2:(NSDictionary *)dict {
//    1.创建对应的对象
    id objc = [[self alloc] init];
//    2.利用runtime给对象总的属性赋值
    unsigned int count = 0;
//    获取类中的所有成员变量
    Ivar *ivarList = class_copyIvarList(self, &count);
    
//    遍历所有成员变量
    for (int i = 0; i < count; i++) {
//         根据角标，从数组中取出对应的成员变量
        Ivar ivar = ivarList[i];
//        获取成员变量的名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        获取成员变量类型
        NSString *ivartype = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
//        替换@\"User\" -->User
        ivartype = [ivartype stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivartype = [ivartype stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
//        处理成员属性名——>字典中的key（去掉_,从第一个角标开始截取）
        NSString *key = [ivarName substringFromIndex:1];
//        根据成员属性名去字典中查找对应的value
        id value = dict[key];
        
//       二级转换 如果字典中还有字典，也需要把对应的字典转换成模型
//        判断下value 是否是字典 并且是自定义对象才需要转换
        if ([value isKindOfClass:[NSDictionary class]] && [ivartype hasPrefix:@"NS"]) {
//            字典转换模型 useDict ——>User模型 转换成哪个模型
//            根据字符串类名生成类对象
            Class modelClass = NSClassFromString(ivartype);
            
            if (modelClass) {//有对应的模型才需要转
//            把字典转模型
                value = [modelClass modelWithDic2:value];
            }
        }
        
//        给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;

}

/*
 动态添加方法
    应用场景：如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表，可以使用动态给某个类添加方法解决。
 解释：OC中我们会习惯使用懒加载，当用到的时候才去加载它，但是实际上只要一个类实现了某个方法，就会被加载进内存。当我们不想加载那么多方法的时候，就会使用Runtime动态添加方法。
 
 需求：runtime 动态添加方法处理调用一个 未实现的方法 和 去除报错。
 
 
 */

/*
 动态变量控制
 
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
