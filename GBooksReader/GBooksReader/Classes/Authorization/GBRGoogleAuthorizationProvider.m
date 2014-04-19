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

static NSString *const kGoogleAuthenticationBaseURLString = @"https://accounts.google.com/";

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

- (NSString *)queryParameterWithKey:(NSString *)key value:(NSString *)value {
    return [NSString stringWithFormat:@"%@=%@", key, value];
}

- (NSURL *)initialAuthorizationURLForClientID:(NSString *)clientID redirectURI:(NSString *)redirectURI {
    NSParameterAssert([clientID length] > 0);
    NSParameterAssert([redirectURI length] > 0);

    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:@"o/oauth2/auth" relativeToURL:[NSURL URLWithString:kGoogleAuthenticationBaseURLString]] resolvingAgainstBaseURL:YES];
    components.query = [@[
            [self queryParameterWithKey:@"client_id" value:clientID],
            [self queryParameterWithKey:@"redirect_uri" value:redirectURI],
            [self queryParameterWithKey:@"response_type" value:@"code"],
    ] componentsJoinedByString:@"&"];
    return [components URL];
}

- (NSURLRequest *)tokenAcquizitionRequestForClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURI:(NSString *)redirectURI code:(NSString *)code {
    NSParameterAssert([clientID length] > 0);
    NSParameterAssert([clientSecret length] > 0);
    NSParameterAssert([redirectURI length] > 0);
    NSParameterAssert([code length] > 0);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"o/oauth2/token" relativeToURL:[NSURL URLWithString:kGoogleAuthenticationBaseURLString]]];
    [request setHTTPMethod:@"POST"];

    NSData *body = [[@[
            [self queryParameterWithKey:@"code" value:code],
            [self queryParameterWithKey:@"client_id" value:clientID],
            [self queryParameterWithKey:@"client_secret" value:clientSecret],
            [self queryParameterWithKey:@"redirect_uri" value:redirectURI],
            [self queryParameterWithKey:@"grant_type" value:@"authorization_code"],
    ] componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];

    return [request copy];
}


@end

