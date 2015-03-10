//
//  NWCustomURLCache.m
//  Pods
//
//  Created by cailu on 15/3/9.
//  Copyright (c) 2015年 MeiQi iOS Dev Team. All rights reserved.
//

#import "NWCustomURLCache.h"

#define kCustomURLCacheExpiration @"CustomURLCacheExpiration"

@implementation NWCustomURLCache
+ (void)useCustomURLCache {
    [NSURLCache setSharedURLCache:[NWCustomURLCache shareNWCustomURLCache]];
}

+ (instancetype)shareNWCustomURLCache {
    static NWCustomURLCache *_standardURLCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[NWCustomURLCache alloc]
                             initWithMemoryCapacity:(MemoryCapacity * 1024 * 1024)
                             diskCapacity:(DiskCapacity * 1024 * 1024)
                             diskPath:nil];
    });
    return _standardURLCache;
}

- (BOOL)isHit:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse) {
        NSDate *cacheData = cachedResponse.userInfo[kCustomURLCacheExpiration];
        NSString *interval = cachedResponse.userInfo[kExpirationInterval];
        if (![self isOverdue:cacheData expirationInterval:interval.doubleValue]) {
            return YES;
        }
    }
    return NO;
}

+ (void)setExpirationInterval:(NSMutableURLRequest *)request interval:(NSTimeInterval)expirationInterval {
    if (expirationInterval >= 0) {
        [request setValue:[[NSNumber numberWithDouble:expirationInterval] stringValue]
       forHTTPHeaderField:kExpirationInterval];
    } else {
        [request setValue:[[NSNumber numberWithDouble:CustomURLCacheExpirationInterval] stringValue]
       forHTTPHeaderField:kExpirationInterval];
    }
}

#pragma mark - overwrite
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse) {
        NSDate *cacheData = cachedResponse.userInfo[kCustomURLCacheExpiration];
        NSString *interval = cachedResponse.userInfo[kExpirationInterval];
        if ([self isOverdue:cacheData expirationInterval:interval.doubleValue]) {
            return nil;
        }
    }
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSMutableDictionary *userInfo = [self buildUserInfo:cachedResponse forRequest:request];
    
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];
    
    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

#pragma mark - private method
- (NSMutableDictionary *)buildUserInfo:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[kCustomURLCacheExpiration] = [NSDate date];
    userInfo[kExpirationInterval] = [self interval:cachedResponse forRequest:request];
    return userInfo;
}

- (NSNumber *)interval:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSString *intervalString = [request valueForHTTPHeaderField:kExpirationInterval];
    if (intervalString) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        return [formatter numberFromString:intervalString];
    }
    return [NSNumber numberWithDouble:CustomURLCacheExpirationInterval];
}

- (BOOL)isOverdue:(NSDate *)data expirationInterval:(NSTimeInterval)expirationInterval
{
    NSDate *overdueData = [data dateByAddingTimeInterval:expirationInterval];
    return [overdueData compare:[NSDate date]] == NSOrderedAscending;
}

@end
