//
//  GBRMyUploadedBooksStorage+GBRTests.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;

#import "GBRMyUploadedBooksStorage.h"


@interface GBRMyUploadedBooksStorage (Tests)

- (NSDictionary *)booksByIDsDictionaryFromBooks:(NSArray *)books;
- (NSString *)booksStoragePath;

@end