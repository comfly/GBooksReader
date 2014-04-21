//
//  GBRGoogleAuthorization.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@class GPPSignInButton;

@interface GBRGoogleAuthorization : NSObject

- (UIViewController *)authorizationViewController;
- (BOOL)handleAuthorizationURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)isAuthenticated;
- (NSString *)token;
- (NSString *)userEmail;

@end
