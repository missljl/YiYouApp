//
//  HttpManager.h
//  FavoriteLimit
//
//  Created by 沈家林 on 15/9/23.
//  Copyright (c) 2015年 沈家林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError *error);


@interface HttpManager : NSObject
+(HttpManager *)shareManager;
-(void)requestWithUrl:(NSString *)urlString withDictionary:(NSDictionary *)dic withSuccessBlock:(SuccessBlock)sucBlock withFailureBlock:(FailureBlock)failureBlock;
-(void)cancelAllRequest;
@end
