//
//  NWJSONResponseSerializer.m
//  Pods
//
//  Created by cailu on 15/3/9.
//  Copyright (c) 2015年 MeiQi iOS Dev Team. All rights reserved.
//

#import "NWJSONResponseSerializer.h"

@implementation NWJSONResponseSerializer

- (id)init {
    self = [super init];
    
    if (self) {
        NSMutableSet *customContentTypes = [self.acceptableContentTypes mutableCopy];
        [customContentTypes addObject:@"text/html"];
        [customContentTypes addObject:@"text/plain"];
        [customContentTypes addObject:@"text/json"];
        [customContentTypes addObject:@"application/json"];
        self.acceptableContentTypes = [customContentTypes copy];
    }
    return self;
}
@end
