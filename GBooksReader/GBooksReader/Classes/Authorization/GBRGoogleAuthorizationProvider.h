//
//  GBRGoogleAuthorizationProvider.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@interface GBRGoogleAuthorizationProvider : NSObject

@property (nonatomic) NSString *token;

- (NSURL *)initialAuthorizationURLForClientID:(NSString *)clientID redirectURI:(NSString *)redirectURI;

@end