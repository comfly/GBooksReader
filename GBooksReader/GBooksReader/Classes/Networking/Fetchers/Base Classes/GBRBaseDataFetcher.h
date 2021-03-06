//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseNetworkFetcher.h"


@interface GBRBaseDataFetcher : GBRBaseNetworkFetcher

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithToken:(NSString *)token;

- (void)cancelTaskForPromise:(PMKPromise *)promise;

@end
