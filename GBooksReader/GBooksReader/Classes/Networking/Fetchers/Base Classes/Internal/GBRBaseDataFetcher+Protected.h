//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseDataFetcher.h"


@class REMHTTPSessionManager;

@interface GBRBaseDataFetcher (Protected)

@property (nonatomic, readonly) REMHTTPSessionManager *manager;
- (void (^)(NSURLSessionDataTask *, NSError *))defaultNetworkErrorProcessingBlockWithRejecter:(PromiseResolver)rejecter;

typedef void (^GBRNetworkFetcherCancellationBlock)(void);
- (Promise *)registerCancellationBlock:(GBRNetworkFetcherCancellationBlock)cancellationBlock withPromise:(Promise *)promise;

@end
