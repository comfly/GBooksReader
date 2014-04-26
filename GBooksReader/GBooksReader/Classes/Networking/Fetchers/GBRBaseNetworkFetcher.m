//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBaseNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"


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
        _manager = [[REMHTTPSessionManager alloc] initWithBaseURL:[self baseURL] sessionConfiguration:[self sessionConfiguration]];
        _manager.requestSerializer = [self requestSerializerWithToken:token];
        _manager.responseSerializer = [self responseSerializer];

        NSPointerFunctionsOptions keyOptions = NSPointerFunctionsOpaqueMemory | NSMapTableObjectPointerPersonality;
        NSPointerFunctionsOptions valueOptions = NSMapTableStrongMemory | NSPointerFunctionsObjectPersonality;
        _tasksByPromises = [NSMapTable mapTableWithKeyOptions:keyOptions valueOptions:valueOptions];
    }

    return self;
}

- (Promise *)initiateTask:(NSURLSessionTask *)task forPromise:(Promise *)promise {
    __block Promise *extendedPromise = promise.then(^(id result) {
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
    @weakify(self);
    return ^(NSURLSessionDataTask *_, NSError *error) {
        @strongify(self);
        if ([[error domain] isEqualToString:NSURLErrorDomain]) {
            [self processStandardNetworkError:error];
        }
        if ([self mustLogNetworkError:error]) {
            DDLogCError(@"Network error: %@", error);
        }
        [deferred reject:error];
    };
}

- (void)processStandardNetworkError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain]);

    switch ([error code]) {
        case NSURLErrorCancelled:
            [self respondToOperationCancelledError:error];
            break;
        case NSURLErrorNotConnectedToInternet:
            [self respondToNotConnectedError:error];
            break;
        case NSURLErrorNetworkConnectionLost:
            [self respondToNetworkConnectionError:error];
            break;
        default:
            // Do nothing special. Let code of upper levels handle this.
            break;
    }
}

- (void)respondToNetworkConnectionError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorNetworkConnectionLost);
    // Do processing.
}

- (void)respondToNotConnectedError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorNotConnectedToInternet);
    // Do processing.
}

- (void)respondToOperationCancelledError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorCancelled);
    // Do nothing. User cancelled operation just goes in vain.
}

- (BOOL)mustLogNetworkError:(NSError *)error {
    return !([error isOfflineError] || [error isUserCancelled]);
}

- (REMCompoundResponseSerializer *)responseSerializer {
    return [REMCompoundResponseSerializer serializer];
}

- (AFHTTPRequestSerializer *)requestSerializerWithToken:(NSString *)token {
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [serializer setValue:[self tokenHeaderValueForToken:token] forHTTPHeaderField:@"Authorization"];

    return serializer;
}

- (NSURL *)baseURL GBR_CONST {
    return [GBRConfiguration configuration].baseURL;
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (NSString *)tokenHeaderValueForToken:(NSString *)token {
    return FORMAT(@"Bearer %@", token);
}

@end
