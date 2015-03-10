//
//  NWHttpRequestSerializer.m
//  Pods
//
//  Created by cailu on 15/3/9.
//  Copyright (c) 2015年 MeiQi iOS Dev Team. All rights reserved.
//

#import "NWHttpRequestSerializer.h"

@implementation NWHttpRequestSerializer
- (id)init {
    self = [super init];
    
    if (self) {
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error {
    if (!URLString) {
        NSLog(@"=========NetWorker ERROR IN Build Request!===== in %s",__FUNCTION__);
        return nil;
    }
    
    NSMutableURLRequest *req = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    [req setCachePolicy:self.cachePolicy];
    
    return req;
}
@end
