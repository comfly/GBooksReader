//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseNetworkFetcher.h"


@interface GBRBaseFileFetcher : GBRBaseNetworkFetcher

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUniqueIdentifier:(NSString *)identifier token:(NSString *)token URL:(NSURL *)URL;

@end
