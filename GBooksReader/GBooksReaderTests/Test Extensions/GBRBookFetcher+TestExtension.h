//
// Created by Dmitry Zakharov on 5/20/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;

#import "GBRBookFetcher.h"

@interface GBRBookFetcher (TestExtension)

+ (NSURL *)buildDestinationURLForBookWithID:(NSString *)ID type:(GBRBookType)type;
- (NSURLSessionConfiguration *)sessionConfiguration;

@end
