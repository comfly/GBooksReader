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

- (Promise *)initiateTask:(NSURLSessionTask *)task forPromise:(Promise *)promise;

- (void)completeTaskForPromise:(Promise *)promise;

- (void (^)(NSURLSessionDataTask *, NSError *))defaultNetworkErrorProcessingBlockWithDeferred:(Deferred *)deferred;

@end
