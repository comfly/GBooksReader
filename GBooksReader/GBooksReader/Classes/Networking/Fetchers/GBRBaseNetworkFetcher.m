//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBaseNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRConfiguration.h"


@interface GBRBaseNetworkFetcher ()

@property (nonatomic, readonly, copy) NSString *token;
@property (nonatomic, readonly) NSMapTable *tasksByPromises;

@end

@implementation GBRBaseNetworkFetcher

- (instancetype)initWithToken:(NSString *)token {
    NSParameterAssert(token);

    self = [super init];
    if (self) {
        _token = [token copy];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self baseURL] sessionConfiguration:[self sessionConfiguration]];
        _manager.requestSerializer = [self requestSerializerWithToken:token];
        _manager.responseSerializer = [self responseSerializer];

        _tasksByPromises = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality | NSPointerFunctionsOpaqueMemory
                                                 valueOptions:NSMapTableStrongMemory | NSPointerFunctionsObjectPersonality];
    }

    return self;
}

- (Promise *)initiateTask:(NSURLSessionTask *)task forPromise:(Promise *)promise {
    Promise *extendedPromise = promise.then(^(id result) {
        [self completeTaskForPromise:extendedPromise];
        return result;
    }).catch(^(id error) {
        [self completeTaskForPromise:extendedPromise];
        return error;
    });
    self.tasksByPromises[extendedPromise] = task;
    return extendedPromise;
}

- (void)completeTaskForPromise:(Promise *)promise {
    [self.tasksByPromises removeObjectForKey:promise];
}

- (void)cancelTaskForPromise:(Promise *)promise {
    [self.tasksByPromises[promise] cancel];
    [self.tasksByPromises removeObjectForKey:promise];
}

- (void (^)(NSURLSessionDataTask *, NSError *))defaultNetworkErrorProcessingBlockWithDeferred:(Deferred *)deferred {
    return ^(NSURLSessionDataTask *task, NSError *error) {
        DDLogCError(@"Network error: %@", error);
        [deferred reject:error];
    };
}

- (AFHTTPResponseSerializer *)responseSerializer {
    return [AFJSONResponseSerializer serializer];
}

- (AFHTTPRequestSerializer *)requestSerializerWithToken:(NSString *)token {
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [serializer setValue:[self tokenHeaderValueForToken:token] forHTTPHeaderField:@"Authorization"];

    return serializer;
}

- (NSURL *)baseURL {
    return [GBRConfiguration configuration].baseURL;
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (NSString *)tokenHeaderValueForToken:(NSString *)token {
    return FORMAT(@"Bearer %@", token);
}

@end
