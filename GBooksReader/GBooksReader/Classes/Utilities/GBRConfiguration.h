//
//  GBRConfiguration.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@interface GBRConfiguration : NSObject

@property (nonatomic, readonly) NSString *clientID;
@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) NSString *booksScope;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)configuration;

@end
