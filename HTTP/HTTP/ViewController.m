//
//  ViewController.m
//  HTTP
//
//  Created by 十月 on 2017/8/17.
//  Copyright © 2017年 October. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//1--------同步的GET请求  NSURLConnection
- (void)synchronousRequest {
    
//1.创建请求路径
    NSURL *url = [NSURL URLWithString:@""];
//2.通过请求路径url 创建请求对象request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//3.向服务器发送同步请求 data   "Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h"
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//sendSynchronousRequest阻塞式的方法 等待服务器返回数据
    
//4.解析服务器返回的数据（解析成字符串）
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);

}

//2---------异步GET请求
- (void)sendAsynchronousRequest {
//    1.创建请求路径url
    NSURL *url = [NSURL URLWithString:@""];
    
//    2.通过请求路径url 创建请求对象request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    3.向服务器发送异步请求  "Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h")
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"请求完毕了回调这个block");
//        4.解析服务器返回的数据 （解析成字符串）
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
    }];
}


//3--------通过代理发送异步请求
- (void)createAsynchronous {
//    创建请求的URL
    NSURL *url = [NSURL URLWithString:@""];
//    通过URL创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    通过代理创建链接对象  "Use NSURLSession (see NSURLSession.h)")
    [NSURLConnection connectionWithRequest:request delegate:self];
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
//    startImmediately是否立即发送请求
    
//    开始发送请求
    [conn start];
    
//    取消发送请求
    [conn cancel];
    
}
//代理需要实现的方法

// 接收到服务器的响应
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

// 接收到服务器的数据（如果数据量比较大，这个方法会被调用多次）
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

// 不断拼接服务器返回的数据
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

// 请求失败（比如请求超时）
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;


//4-----------同步请求
- (void)creareSyncRequest {
//    创建请求路径url
    NSURL *url = [NSURL URLWithString:@""];
//    通过请求路径创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//    更改请求方法
    request.HTTPMethod = @"POST";
    
//    设置请求体
    request.HTTPBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    
//    设置超时 5秒后
    request.timeoutInterval = 5;
    
//    设置请求头 （非必要 看情况）
//    [request setValue:@"iOS 9.0" forHTTPHeaderField:@"User_Agent"];
    
//    向服务器发送同步请求
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}
//5-----------异步POST请求
- (void)createAsyncPOSTRequest {
//    创建请求路径
    NSURL *url = [NSURL URLWithString:@""];
////    _____中文URL处理
//    NSString *urlStr = @"";
////    将中文URL转码
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    
//    通过请求路径url创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//    更改请求方法
    request.HTTPMethod = @"POST";
    
//    设置请求体
    request.HTTPBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    
//    设置超时
    request.timeoutInterval = 5;
    
//    设置请求头
    [request setValue:@"iOS 9.0" forHTTPHeaderField:@"User-Agent"];
    
//    向服务器发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"_____请求失败");
        } else {
            NSLog(@"------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    
}

//NSURLSession
//GET请求
//1-----------第一种GET请求
- (void)createGETRequest {
    //获得NSURSession对象
    NSURLSession *session  = [NSURLSession sharedSession];
//    创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
//    启动任务
    [task resume];
}
//2----------第二种GET请求
- (void)createGETRequest2 {
//    获取NSURSession
    NSURLSession *session = [NSURLSession sharedSession];
    
//    创建任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@""] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
//    启动任务
    [task resume];
}


//POST 请求
- (void)createPOSTRequest {
    NSURLSession *session = [NSURLSession sharedSession];
    
//    创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@""]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
//    创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
        
//        任务启动
        [task resume];

    }];

}
//通过代理发送请求
- (void)createDelegateRequest {
    NSURLSession *session = [NSURLSession sharedSession];
//    创建任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    //        任务启动
    [task resume];
}
// 1.接收到服务器的响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler { // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
// void (^)(NSURLSessionResponseDisposition)
}

// 2.接收到服务器的数据（可能会被调用多次）
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data { NSLog(@"%s", __func__);
}

// 3.请求成功或者失败（如果失败，error有值）
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error { NSLog(@"%s", __func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
