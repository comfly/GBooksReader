//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


@class GBRBaseNetworkFetcher;

@interface GBRHTTPClientProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)provider;

- (GBRBaseNetworkFetcher *)objectForKeyedSubscript:(NSString *)token;

@end
