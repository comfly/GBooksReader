//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseDataFetcher.h"


@interface GBRMyUploadedBooksNetworkFetcher : GBRBaseDataFetcher

/**
* Promise of NSArray of GBRBook
*/
- (PMKPromise *)loadMyUploadedBooks;

@end
