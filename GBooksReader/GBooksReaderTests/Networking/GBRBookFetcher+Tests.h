//
// Created by Dmitry Zakharov on 5/20/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;

#import "GBRBookFetcher.h"

@interface GBRBookFetcher (Tests)

+ (NSURL *)buildDestinationURLForBookWithID:(NSString *)ID type:(GBRBookType)type;
+ (NSURLSessionConfiguration *)sessionConfigurationWithIdentifier:(NSString *)identifier;

@end
