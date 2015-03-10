//
//  BaseNetworkService.h
//  NetWorker
//
//  Created by cai on 7/31/14.
//  Copyright (c) 2014 MeiQi iOS Dev Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "NWHttpRequestSerializer.h"
#import "NWJSONResponseSerializer.h"

// default open cache
#define Open_Request_Cache  1
#define Error_Argument      @"参数错误"

typedef void(^MNSCompletionBlock)(id responseData, AFHTTPRequestOperation *operation);
typedef void(^MNSFailureBlock)(NSString *errorString, AFHTTPRequestOperation *operation);

/**
 *  Base networking frame work
 */
@interface BaseNetworkService : NSObject

@property (nonatomic,readonly) AFHTTPRequestOperationManager *operationManager;

- (NSURLRequest *)GET:(NSString *)urlString
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure;

- (NSURLRequest *)GET:(NSString *)urlString
             hitCache:(void (^)(BOOL isHit))hitCache
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure;

- (NSURLRequest *)GET:(NSString *)urlString
             hitCache:(void (^)(BOOL isHit))hitCache
             interval:(NSTimeInterval)expirationInterval
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure;

- (NSURLRequest *)GET:(NSString *)urlString
            withCache:(BOOL)useCache
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure;

- (NSURLRequest *)GET:(NSString *)urlString
            withCache:(BOOL)useCache
             interval:(NSTimeInterval)expirationInterval
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure;

- (NSURLRequest *)GET:(NSString *)urlString
     withRefreshCache:(BOOL)beRefreshCache
           parameters:(NSDictionary *)parameters
              success:(MNSCompletionBlock)success
              failure:(MNSFailureBlock)failure;

- (NSURLRequest *)GET:(NSString *)urlString
           parameters:(NSDictionary *)parameters
             hitCache:(void (^)(BOOL isHit))hitCache
             interval:(NSTimeInterval)expirationInterval
     withRefreshCache:(BOOL)beRefreshCache
         successBlock:(MNSCompletionBlock)success
         failureBlock:(MNSFailureBlock)failure;

- (NSURLRequest *)POST:(NSString *)urlString
            parameters:(NSDictionary *)parameters
               success:(MNSCompletionBlock)success
               failure:(MNSFailureBlock)failure;

/**
 *  cancel network requests
 */
- (void)cancelRequests;

- (void)removeCachedResponseForOperation:(AFHTTPRequestOperation *)operation;

- (void)removeCachedResponseForRequest:(NSURLRequest *)request;
@end

@interface BaseNetworkService (Deprecated)
- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE;

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          hitCache:(void (^)(BOOL isHit))hitCache
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE;

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                          hitCache:(void (^)(BOOL isHit))hitCache
                          interval:(NSTimeInterval)expirationInterval
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE;

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                         withCache:(BOOL)useCache
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE;

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                         withCache:(BOOL)useCache
                          interval:(NSTimeInterval)expirationInterval
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE;

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                  withRefreshCache:(BOOL)beRefreshCache
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *))failure DEPRECATED_ATTRIBUTE;

- (void)POSTWithURLString:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseData))success
                  failure:(void (^)(NSString *errorString))failure DEPRECATED_ATTRIBUTE;
@end
