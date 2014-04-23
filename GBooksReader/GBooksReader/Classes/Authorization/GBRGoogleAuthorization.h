//
//  GBRGoogleAuthorization.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@protocol GBRGoogleAuthorizationDelegate;

@interface GBRGoogleAuthorization : NSObject

- (instancetype)initWithDelegate:(id<GBRGoogleAuthorizationDelegate>)delegate DESIGNATED_INITIALIZER;

- (UIViewController *)authorizationViewController;
- (BOOL)handleAuthorizationURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)isAuthenticated;
- (BOOL)trySilentAuthentication;
- (NSString *)token;
- (NSString *)userEmail;

@end


@protocol GBRGoogleAuthorizationDelegate <NSObject>

- (void)authorizationDidSuccessfullyAuthorized:(GBRGoogleAuthorization *)authorization;

@optional
- (void)authorization:(GBRGoogleAuthorization *)authorization didFailAuthorizationWithError:(NSError *)error;

@end
