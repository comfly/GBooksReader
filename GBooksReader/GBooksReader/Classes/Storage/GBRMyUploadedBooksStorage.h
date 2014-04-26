//
//  GBRMyUploadedBooksStorage.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;
#import "GBRStorage.h"


@interface GBRMyUploadedBooksStorage : GBRStorage

/**
* NSDictionary of ID->GBRBook
*/
- (NSDictionary *)loadAllBooks;

/**
* NSDictionary of ID->GBRBook
*/
- (void)storeBooks:(NSDictionary *)books;

@end