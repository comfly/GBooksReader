//
//  GBRGoogleAuthorizationProvider.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRGoogleAuthorizationProvider.h"
#import <SSKeychain/SSKeychain.h>


@implementation GBRGoogleAuthorizationProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        _token = [self loadTokenFromKeychain];
    }

    return self;
}

- (NSString *)loadTokenFromKeychain {
    __autoreleasing NSError *error;
    NSString *token = [SSKeychain passwordForService:[self serviceName] account:[self account] error:&error];
    if (error && [error code] != errSecItemNotFound) {
        DDLogError(@"Error retrieving Token from Keychain: %@ [%@]", error, [error localizedDescription]);
    }

    return token;
}

- (NSString *)serviceName {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString *)account {
    return @"UserAccount";
}

- (void)setToken:(NSString *)token {
    if (![_token isEqualToString:token]) {
        _token = [token copy];

        __autoreleasing NSError *error;
        if (![SSKeychain setPassword:token forService:[self serviceName] account:[self account] error:&error]) {
            DDLogError(@"Error storing Token in Keychain: %@ [%@]", error, [error localizedDescription]);
        }
    }
}

@end

