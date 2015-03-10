//
//  BaseNetworkService+RACSupport.m
//  NetWorker
//
//  Created by cailu on 14/10/30.
//  Copyright (c) 2014年 MeiQi iOS Dev Team. All rights reserved.
//

#import "BaseNetworkService+RACSupport.h"
#import "RACAFNetworking.h"

@implementation BaseNetworkService (RACSupport)
- (RACSignal *)rac_GETWithCache:(NSString *)URLString
                     parameters:(NSDictionary *)parameters {
    return [self rac_GET:URLString parameters:parameters withCache:YES];
}

- (RACSignal *)rac_GETWithoutCache:(NSString *)URLString
                        parameters:(NSDictionary *)parameters {
    return [self rac_GET:URLString parameters:parameters withCache:NO];
}

- (RACSignal *)rac_POSTWithoutCache:(NSString *)URLString
                         parameters:(NSDictionary *)parameters {
    
    if (nil == URLString) {
        return  [RACSignal error:[NSError errorWithDomain:@"subject" code:1 userInfo:@{NSLocalizedDescriptionKey: @"URL 不能为nil"}]];
    }
    return [self.operationManager rac_POST:URLString parameters:parameters];
}

- (RACSignal *)rac_GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters
             withCache:(BOOL)useCache {
    if (nil == URLString) {
        return  [RACSignal error:[NSError errorWithDomain:@"subject" code:1 userInfo:@{NSLocalizedDescriptionKey: @"URL 不能为nil"}]];
    }
    if (useCache) {
#if Open_Request_Cache
        self.operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    }
    return [self.operationManager rac_GET:URLString parameters:parameters];
}
@end