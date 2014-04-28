//
//  GBRAssembly.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@interface GBRAssembly : TyphoonAssembly

- (id)authorizer;
- (id)myUploadedBooksNetworkFetcher;
- (id)myUploadedBooksStorage;

@end
