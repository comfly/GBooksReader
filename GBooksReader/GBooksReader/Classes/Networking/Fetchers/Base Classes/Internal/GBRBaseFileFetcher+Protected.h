//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;

#import "GBRBaseFileFetcher.h"

@interface GBRBaseFileFetcher (Protected)

@property (nonatomic, readonly, copy) NSString *uniqueIdentifier;
@property (nonatomic, readonly) NSURL *URL;

- (NSURLRequest *)request;

@end
