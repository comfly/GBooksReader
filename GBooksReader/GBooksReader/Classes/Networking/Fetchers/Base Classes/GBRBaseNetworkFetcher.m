//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBaseNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"


@implementation GBRBaseNetworkFetcher

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
