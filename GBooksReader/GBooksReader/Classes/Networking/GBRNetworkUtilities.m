//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRNetworkUtilities.h"


NSString *const GBRNetworkAuthorizationHeaderKey = @"Authorization";

NSString *GBRNetworkAuthorizationHeaderValue(NSString *token) {
    return FORMAT(@"Bearer %@", token);
}
