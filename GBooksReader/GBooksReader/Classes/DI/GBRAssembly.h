//
//  GBRAssembly.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@protocol GBRAuthorization;
@class GBRBaseNetworkFetcher;

@interface GBRAssembly : TyphoonAssembly

- (id<GBRAuthorization>)authorizer;

- (id)myUploadedBooksNetworkFetcher;

- (id)myUploadedBooksStorage;

@end
