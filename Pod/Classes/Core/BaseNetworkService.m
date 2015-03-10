//
//  BaseNetworkService.m
//  NetWorker
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 MeiQi iOS Dev Team. All rights reserved.
//

#import "BaseNetworkService.h"
#import "NWCustomURLCache.h"

@interface BaseNetworkService ()

@property (nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic) AFHTTPSessionManager *sessoinManager;
@end

@implementation BaseNetworkService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NWJSONResponseSerializer *jsonResponseSerializer = [NWJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NWHttpRequestSerializer *httpRequestSerializer = [NWHttpRequestSerializer serializer];
        
        _operationManager = [AFHTTPRequestOperationManager manager];
        [_operationManager setRequestSerializer:httpRequestSerializer];
        [_operationManager setResponseSerializer:jsonResponseSerializer];
    }
    return self;
}

#pragma mark - Get Method
- (NSURLRequest *)GET:(NSString *)urlString
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure {
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    return [self GET:urlString
          parameters:parameters
            hitCache:nil
            interval:CustomURLCacheExpirationInterval
    withRefreshCache:NO
        successBlock:success
        failureBlock:failure];
}

- (NSURLRequest *)GET:(NSString *)urlString
             hitCache:(void (^)(BOOL isHit))hitCache
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure {
    return [self GET:urlString
            hitCache:hitCache
            interval:CustomURLCacheExpirationInterval
          parameters:parameters
             success:success
             failure:failure];
}

- (NSURLRequest *)GET:(NSString *)urlString
             hitCache:(void (^)(BOOL isHit))hitCache
             interval:(NSTimeInterval)expirationInterval
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure {
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    return [self GET:urlString
          parameters:parameters
            hitCache:hitCache
            interval:expirationInterval
    withRefreshCache:NO
        successBlock:success
        failureBlock:failure];
}

- (NSURLRequest *)GET:(NSString *)urlString
            withCache:(BOOL)useCache
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure {
    return [self GET:urlString
           withCache:useCache
            interval:CustomURLCacheExpirationInterval
          parameters:parameters
             success:success
             failure:failure];
}

- (NSURLRequest *)GET:(NSString *)urlString
            withCache:(BOOL)useCache
             interval:(NSTimeInterval)expirationInterval
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure {
    if (useCache) {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    } else {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    return [self GET:urlString
          parameters:parameters
            hitCache:nil
            interval:expirationInterval
    withRefreshCache:NO
        successBlock:success
        failureBlock:failure];
}

- (NSURLRequest *)GET:(NSString *)urlString
     withRefreshCache:(BOOL)beRefreshCache
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure {
    if (!beRefreshCache) {
        //如果不refresh，这里就是一次性请求的，且不会冲cache
        return [self GET:urlString withCache:NO parameters:parameters success:success failure:failure];
    } else {
        return [self GET:urlString parameters:parameters hitCache:nil interval:CustomURLCacheExpirationInterval withRefreshCache:beRefreshCache successBlock:success failureBlock:failure];
    }
}

- (NSURLRequest *)GET:(NSString *)urlString
           parameters:(NSDictionary *)parameters
             hitCache:(void (^)(BOOL isHit))hitCache
             interval:(NSTimeInterval)expirationInterval
     withRefreshCache:(BOOL)beRefreshCache
         successBlock:(MNSCompletionBlock)success
         failureBlock:(MNSFailureBlock)failure {
    if (!urlString) {
        if (failure) {
            failure(Error_Argument,nil);
        }
        return nil;
    }
    return [self requestWithMethod:@"GET" URLString:urlString parameters:parameters hitCache:hitCache interval:expirationInterval withRefreshCache:beRefreshCache successBlock:success failureBlock:failure];
}

#pragma mark - Post Method
- (NSURLRequest *)POST:(NSString *)urlString
            parameters:(NSDictionary *)parameters
               success:(MNSCompletionBlock)success
               failure:(MNSFailureBlock)failure
{
    if (!urlString) {
        if (failure) {
            failure(Error_Argument,nil);
        }
        return nil;
    }
    _operationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    return [_operationManager POST:urlString
                        parameters:parameters
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               success(responseObject,operation);
                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               if (failure && error) {
                                   if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                                       failure([error.userInfo objectForKey:NSLocalizedDescriptionKey],operation);
                                   } else if([error.userInfo objectForKey:@"NSDebugDescription"]){
                                       failure([error.userInfo objectForKey:@"NSDebugDescription"],operation);
                                   }
                               }
                           }].request;
}

/**
 *  cancel requests
 */
- (void)cancelRequests {
    [_operationManager.operationQueue cancelAllOperations];
}

- (void)removeCachedResponseForOperation:(AFHTTPRequestOperation *)operation {
    [self removeCachedResponseForRequest:operation.request];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [[NWCustomURLCache shareNWCustomURLCache] removeCachedResponseForRequest:request];
}

#pragma mark - private method
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error {
    NSString *urlstring = [NSURL URLWithString:URLString
                                 relativeToURL:_operationManager.baseURL].absoluteString;
    if (!urlstring) {
        urlstring = URLString;
    }
    return [_operationManager.requestSerializer requestWithMethod:method
                                                        URLString:urlstring
                                                       parameters:parameters
                                                            error:error];
}

- (NSURLRequest *)requestWithMethod:(NSString *)method
                          URLString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                           hitCache:(void (^)(BOOL isHit))hitCache
                           interval:(NSTimeInterval)expirationInterval
                   withRefreshCache:(BOOL)beRefreshCache
                       successBlock:(MNSCompletionBlock)success
                       failureBlock:(MNSFailureBlock)failure {
    BOOL __block responseFromCache = YES;
    void (^successWrapper)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject,operation);
        }
    };
    
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        if (failure) {
            if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                failure([error.userInfo objectForKey:NSLocalizedDescriptionKey], operation);
            } else if ([error.userInfo objectForKey:@"NSDebugDescription"]) {
                failure([error.userInfo objectForKey:@"NSDebugDescription"], operation);
            }
        }
    };
    
    NSMutableURLRequest *request = [self requestWithMethod:method
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    [NWCustomURLCache setExpirationInterval:request interval:expirationInterval];
    
    if (beRefreshCache) {
        [[NWCustomURLCache shareNWCustomURLCache] removeCachedResponseForRequest:request];
    }
    
    if (hitCache) {
        hitCache([[NWCustomURLCache shareNWCustomURLCache] isHit:request]);
    }
    
    AFHTTPRequestOperation *operation = [_operationManager HTTPRequestOperationWithRequest:request success:successWrapper failure:requestFailureBlock];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        responseFromCache = NO;
        return cachedResponse;
    }];
    [_operationManager.operationQueue addOperation:operation];
    return operation.request;
}

- (void)clearCache:(NSString *)urlString parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    [self removeCachedResponseForRequest:request];
}

#pragma mark - Deprecated
/**
 *  重写GET方法，处理304返回
 *
 *  @param urlString
 *  @param parameters
 *  @param success
 *  @param failure
 */
- (NSURLRequest *)GET:(NSString *)urlString
           parameters:(NSDictionary *)parameters
             hitCache:(void (^)(BOOL isHit))hitCache
             interval:(NSTimeInterval)expirationInterval
              success:(void (^)(id responseData))success
              failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE {
    BOOL __block responseFromCache = YES;
    void (^successWrapper)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    };
    
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        if (failure) {
            if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                failure([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
            } else if ([error.userInfo objectForKey:@"NSDebugDescription"]) {
                failure([error.userInfo objectForKey:@"NSDebugDescription"]);
            }
        }
    };
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    [NWCustomURLCache setExpirationInterval:request interval:expirationInterval];
    
    if (hitCache) {
        hitCache([[NWCustomURLCache shareNWCustomURLCache] isHit:request]);
    }
    AFHTTPRequestOperation *operation = [_operationManager HTTPRequestOperationWithRequest:request success:successWrapper failure:requestFailureBlock];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        responseFromCache = NO;
        return cachedResponse;
    }];
    [_operationManager.operationQueue addOperation:operation];
    return operation.request;
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    return [self GET:urlString
          parameters:parameters
            hitCache:nil
            interval:CustomURLCacheExpirationInterval
             success:success
             failure:failure];
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          hitCache:(void (^)(BOOL isHit))hitCache
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
    return [self GETWithURLString:urlString
                         hitCache:hitCache
                         interval:CustomURLCacheExpirationInterval
                       parameters:parameters
                          success:success
                          failure:failure];
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                          hitCache:(void (^)(BOOL isHit))hitCache
                          interval:(NSTimeInterval)expirationInterval
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    return [self GET:urlString
          parameters:parameters
            hitCache:hitCache
            interval:expirationInterval
             success:success
             failure:failure];
}

/**
 *  Get Method -can close cache
 *
 *  @param urlString  url request string
 *  @param useCache   cache flag
 *  @param parameters parameters with dictionary type
 *  @param success    success block
 *  @param failure    failure block
 */
- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                         withCache:(BOOL)useCache
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
    return [self GETWithURLString:urlString
                        withCache:useCache
                         interval:CustomURLCacheExpirationInterval
                       parameters:parameters
                          success:success
                          failure:failure];
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                         withCache:(BOOL)useCache
                          interval:(NSTimeInterval)expirationInterval
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
    if (useCache) {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    } else {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    return [self GET:urlString
          parameters:parameters
            hitCache:nil
            interval:expirationInterval
             success:success
             failure:failure];
}

/**
 *  Get Method -can refresh cache
 *
 *  @param urlString      url request string
 *  @param beRefreshCache refresh cache
 *  @param parameters     parameters with dictionary type
 *  @param success        success block
 *  @param failure        failure block
 */
- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                  withRefreshCache:(BOOL)beRefreshCache
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *))failure {
    if (!beRefreshCache) {
        //如果不refresh，这里就是一次性请求的，且不会冲cache
        return [self GETWithURLString:urlString withCache:NO parameters:parameters success:success failure:failure];
    } else {
        // refresh，清理之前的cache，然后做请求，并缓存到cache中
        [self clearCache:urlString parameters:parameters];
        // request
        return [self GETWithURLString:urlString parameters:parameters success:success failure:failure];
    }
}

/**
 *  Post Method
 */
- (void)POSTWithURLString:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseData))success
                  failure:(void (^)(NSString *errorString))failure {
    [_operationManager POST:urlString
                 parameters:parameters
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        success(responseObject);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure && error) {
                            if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                                failure([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                            } else if([error.userInfo objectForKey:@"NSDebugDescription"]){
                                failure([error.userInfo objectForKey:@"NSDebugDescription"]);
                            }
                        }
                    }];
}
@end
