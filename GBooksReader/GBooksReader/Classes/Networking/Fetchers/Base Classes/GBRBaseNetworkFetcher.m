//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBaseNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"


@interface GBRBaseNetworkFetcher ()

@property (nonatomic, readonly) NSMapTable *tasksByPromises;

@end

@implementation GBRBaseNetworkFetcher

- (instancetype)init {
    self = [super init];
    if (self) {
        NSPointerFunctionsOptions keyOptions = NSPointerFunctionsOpaqueMemory | NSMapTableObjectPointerPersonality;
        NSPointerFunctionsOptions valueOptions = NSMapTableStrongMemory | NSPointerFunctionsObjectPersonality;
        _tasksByPromises = [NSMapTable mapTableWithKeyOptions:keyOptions valueOptions:valueOptions];
    }

    return self;
}

- (Promise *)registerCancellationBlock:(GBRNetworkFetcherCancellationBlock)cancellationBlock withPromise:(Promise *)promise {
    __block Promise *extendedPromise = promise.then(^(id result) {
        [self completeTaskForPromise:extendedPromise];
        return result;
    }).catch(^(id error) {
        [self completeTaskForPromise:extendedPromise];
        return error;
    });

    [self.tasksByPromises setObject:cancellationBlock forKey:extendedPromise];
    return extendedPromise;
}

- (void)completeTaskForPromise:(Promise *)promise {
    [self.tasksByPromises removeObjectForKey:promise];
}

- (void)cancelTaskForPromise:(Promise *)promise {
    GBRNetworkFetcherCancellationBlock cancellationBlock = self.tasksByPromises[promise];
    SAFE_BLOCK_CALL(cancellationBlock);
    [self.tasksByPromises removeObjectForKey:promise];
}

- (BOOL)processStandardNetworkError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain]);

    BOOL processed = NO;
    switch ([error code]) {
        case NSURLErrorCancelled:
            processed = [self respondToOperationCancelledError:error];
            break;
        case NSURLErrorNotConnectedToInternet:
            processed = [self respondToNotConnectedError:error];
            break;
        case NSURLErrorNetworkConnectionLost:
            processed = [self respondToNetworkConnectionError:error];
            break;
        default:
            // Do nothing special. Let code of upper levels handle this.
            break;
    }

    return processed;
}

- (BOOL)respondToNetworkConnectionError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorNetworkConnectionLost);
    // Do processing.
    return YES;
}

- (BOOL)respondToNotConnectedError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorNotConnectedToInternet);
    // Do processing.
    return YES;
}

- (BOOL)respondToOperationCancelledError:(NSError *)error {
    NSParameterAssert([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorCancelled);
    // Do nothing. User cancelled operation just goes in vain.
    return YES;
}

- (BOOL)mustLogNetworkError:(NSError *)error {
    return !([error isOfflineError] || [error isUserCancelled]);
}

@end
