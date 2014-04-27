//
//  GBRStorage+Protected.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;

#import "GBRStorage.h"


@interface GBRStorage (Protected)

- (NSURL *)networkCachesDirectoryURL;
+ (NSURL *)cachesDirectoryURLForUserName:(NSString *)userName;

@end