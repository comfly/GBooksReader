//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBaseFileFetcher.h"
#import "GBRBaseFileFetcher+Protected.h"
#import "GBRNetworkUtilities.h"


@interface GBRBaseFileFetcher ()

@property (nonatomic, readonly, copy) NSString *uniqueIdentifier;
@property (nonatomic, readonly, copy) NSString *token;
@property (nonatomic, readonly) NSURL *URL;

@end

@implementation GBRBaseFileFetcher

- (instancetype)init {
    return [self initWithUniqueIdentifier:nil token:nil URL:nil];
}

- (instancetype)initWithUniqueIdentifier:(NSString *)identifier token:(NSString *)token URL:(NSURL *)URL {
    NSParameterAssert([identifier length] > 0);

    self = [super init];
    if (self) {
        _uniqueIdentifier = [identifier copy];
        _token = [token copy];
        _URL = URL;
    }

    return self;
}

- (NSURLRequest *)request {
    NSMutableURLRequest *result = [NSMutableURLRequest requestWithURL:self.URL];
    [result setValue:GBRNetworkAuthorizationHeaderValue(self.token) forHTTPHeaderField:GBRNetworkAuthorizationHeaderKey];
    return [result copy];
}

@end
