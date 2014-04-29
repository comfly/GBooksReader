//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;

#import <Maris/REMHTTPSessionManager.h>
#import "GBRBaseNetworkFetcher.h"


@interface GBRBaseNetworkFetcher ()

@property (nonatomic, readonly) REMHTTPSessionManager *manager;

- (instancetype)initWithToken:(NSString *)token;

typedef void (^GBRNetworkFetcherCancellationBlock)(void);
- (Promise *)registerCancellationBlock:(GBRNetworkFetcherCancellationBlock)cancellationBlock withPromise:(Promise *)promise;
- (void)completeTaskForPromise:(Promise *)promise;
- (void (^)(NSURLSessionDataTask *, NSError *))defaultNetworkErrorProcessingBlockWithRejecter:(PromiseResolver)rejecter;
- (BOOL)mustLogNetworkError:(NSError *)error;

@end
