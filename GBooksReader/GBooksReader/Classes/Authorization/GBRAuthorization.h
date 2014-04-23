//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


@protocol GBRAuthorization<NSObject>

- (BOOL)isAuthenticated;

- (NSString *)token;

- (NSString *)userEmail;

@end


@protocol GBRAuthorizationDelegate<NSObject>

- (void)authorizationDidSuccessfullyAuthorized:(id<GBRAuthorization>)authorization;

@optional
- (void)authorization:(id<GBRAuthorization>)authorization didFailAuthorizationWithError:(NSError *)error;

@end
