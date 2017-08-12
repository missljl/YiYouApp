//
//  HttpManager.m
//  FavoriteLimit
//
//  Created by 沈家林 on 15/9/23.
//  Copyright (c) 2015年 沈家林. All rights reserved.
//

#import "HttpManager.h"
@implementation HttpManager

+(HttpManager *)shareManager{
    static HttpManager *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (manager==nil) {
            manager=[[HttpManager alloc]init];
        }
    });
    return manager;
}

-(void)requestWithUrl:(NSString *)urlString withDictionary:(NSDictionary *)dic withSuccessBlock:(SuccessBlock)sucBlock withFailureBlock:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/plain",@"application/json",@"text/html",nil];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        sucBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
          failureBlock(error);
    }];
    
//    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        sucBlock(operation,responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       // NSLog(@"error:%@",error);
//       // NSLog(@"request:%@",operation.request);
////NSLog(@"responseString:%@",operation.responseString);
//       // NSLog(@"responseData:%@",operation.responseData);
//        failureBlock(operation,error);
//    }];
    
}

-(void)cancelAllRequest{
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    //manager.operationQueue 拿到管理AFNetWorking请求的队列
    //manager.operationQueue.operationCount 拿到亲求队列中请求的数量
    if (manager.operationQueue.operationCount>0) {
        //取消队列中所有请求
        [manager.operationQueue cancelAllOperations];
    }
}

@end
