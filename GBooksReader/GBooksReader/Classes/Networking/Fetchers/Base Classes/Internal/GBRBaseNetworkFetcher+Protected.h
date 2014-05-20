//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;

#import <Maris/REMHTTPSessionManager.h>
#import "GBRBaseNetworkFetcher.h"


@interface GBRBaseNetworkFetcher ()

- (BOOL)processStandardNetworkError:(NSError *)error;
- (BOOL)mustLogNetworkError:(NSError *)error;

@end
