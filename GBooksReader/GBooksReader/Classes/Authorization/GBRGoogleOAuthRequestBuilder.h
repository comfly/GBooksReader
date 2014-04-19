//
//  GBRGoogleOAuthRequestBuilder.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@interface GBRGoogleOAuthRequestBuilder : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURI:(NSString *)redirectURI DESIGNATED_INITIALIZER;

- (NSURLRequest *)initialRequest;

- (NSURLRequest *)tokenAcquizitionRequestWithCode:(NSString *)code;

@end