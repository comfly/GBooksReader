//
//  GBRGoogleAuthorization.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;

#import "GBRAuthorization.h"


@interface GBRGoogleAuthorization : NSObject<GBRAuthorization>

- (instancetype)initWithDelegate:(id<GBRAuthorizationDelegate>)delegate;
- (instancetype)initWithDelegate:(id<GBRAuthorizationDelegate>)delegate configureSignIn:(BOOL)configureSignIn DESIGNATED_INITIALIZER;

@end

