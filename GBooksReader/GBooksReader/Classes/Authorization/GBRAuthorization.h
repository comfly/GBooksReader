//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


@protocol GBRAuthorization <NSObject>

- (BOOL)isAuthenticated;
- (NSString *)token;

- (NSString *)userName;
- (NSString *)userEmail;

- (UIViewController *)authorizationViewController;
- (BOOL)handleAuthorizationURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)trySilentAuthentication;

@end


@protocol GBRAuthorizationDelegate <NSObject>

- (void)authorizationDidSuccessfullyAuthorized:(id<GBRAuthorization>)authorization;

@optional
- (void)authorization:(id<GBRAuthorization>)authorization didFailAuthorizationWithError:(NSError *)error;

@end
