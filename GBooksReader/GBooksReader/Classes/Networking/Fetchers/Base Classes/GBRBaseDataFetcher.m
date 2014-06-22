//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import <Maris/REMHTTPSessionManager.h>
#import "GBRBaseDataFetcher+Protected.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRNetworkUtilities.h"


@interface GBRBaseDataFetcher ()

@property (nonatomic, readonly) REMHTTPSessionManager *manager;
@property (nonatomic, readonly) NSMapTable *tasksByPromises;
@property (nonatomic, readonly, copy) NSString *token;

@end

@implementation GBRBaseDataFetcher {
    REMHTTPSessionManager *_manager;
}

- (instancetype)initWithToken:(NSString *)token {
    NSParameterAssert([token length] > 0);

    self = [super init];
    if (self) {
        _token = [token copy];
        NSPointerFunctionsOptions keyOptions = NSPointerFunctionsOpaqueMemory | NSMapTableObjectPointerPersonality;
        NSPointerFunctionsOptions valueOptions = NSMapTableStrongMemory | NSPointerFunctionsObjectPersonality;
        _tasksByPromises = [NSMapTable mapTableWithKeyOptions:keyOptions valueOptions:valueOptions];
    }

    return self;
}

- (REMHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [[REMHTTPSessionManager alloc] initWithBaseURL:[self baseURL] sessionConfiguration:[self sessionConfiguration]];
        _manager.requestSerializer = [self requestSerializer];
        _manager.responseSerializer = [self responseSerializer];
    }

    return _manager;
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (AFHTTPRequestSerializer *)requestSerializer {
    AFHTTPRequestSerializer *result = [AFHTTPRequestSerializer serializer];
    [result setValue:GBRNetworkAuthorizationHeaderValue(self.token) forHTTPHeaderField:GBRNetworkAuthorizationHeaderKey];
    return result;
}

- (REMCompoundResponseSerializer *)responseSerializer {
    return [REMCompoundResponseSerializer serializer];
}

- (NSURL *)baseURL GBR_CONST {
    return [GBRConfiguration configuration].baseURL;
}

- (PMKPromise *)registerCancellationBlock:(GBRNetworkFetcherCancellationBlock)cancellationBlock withPromise:(PMKPromise *)promise {
    __block PMKPromise *extendedPromise = promise.then(^(id result) {
        [self completeTaskForPromise:extendedPromise];
        return result;
    }).catch(^(id error) {
        [self completeTaskForPromise:extendedPromise];
        return error;
    });

    [self.tasksByPromises setObject:cancellationBlock forKey:extendedPromise];
    return extendedPromise;
}

- (void)completeTaskForPromise:(PMKPromise *)promise {
    [self.tasksByPromises removeObjectForKey:promise];
}

- (void)cancelTaskForPromise:(PMKPromise *)promise {
    GBRNetworkFetcherCancellationBlock cancellationBlock = self.tasksByPromises[promise];
    SAFE_BLOCK_CALL(cancellationBlock);
    [self.tasksByPromises removeObjectForKey:promise];
}

- (void (^)(NSURLSessionDataTask *, NSError *))defaultNetworkErrorProcessingBlockWithRejecter:(PMKPromiseRejecter)rejecter {
    @weakify(self);
    return ^(NSURLSessionDataTask *_, NSError *error) {
        @strongify(self);
        if ([[error domain] isEqualToString:NSURLErrorDomain]) {
            [self processStandardNetworkError:error];
        }
        if ([self mustLogNetworkError:error]) {
            DDLogCError(@"Network error: %@", error);
        }
        rejecter(error);
    };
}

@end
