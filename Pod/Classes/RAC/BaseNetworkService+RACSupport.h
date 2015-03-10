//
//  BaseNetworkService+RACSupport.h
//  NetWorker
//
//  Created by cailu on 14/10/30.
//  Copyright (c) 2014年 MeiQi iOS Dev Team. All rights reserved.
//

#import "BaseNetworkService.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface BaseNetworkService (RACSupport)
- (RACSignal *)rac_GETWithCache:(NSString *)URLString
                     parameters:(NSDictionary *)parameters;

- (RACSignal *)rac_GETWithoutCache:(NSString *)URLString
                        parameters:(NSDictionary *)parameters;

- (RACSignal *)rac_GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters
             withCache:(BOOL)useCache;

- (RACSignal *)rac_POSTWithoutCache:(NSString *)URLString
                         parameters:(NSDictionary *)parameters;
@end
