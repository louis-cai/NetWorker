//
//  NWHttpRequestSerializer.h
//  Pods
//
//  Created by cailu on 15/3/9.
//  Copyright (c) 2015年 MeiQi iOS Dev Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface NWHttpRequestSerializer : AFHTTPRequestSerializer

@property (nonatomic) NSURLRequestCachePolicy cachePolicy;

@end
