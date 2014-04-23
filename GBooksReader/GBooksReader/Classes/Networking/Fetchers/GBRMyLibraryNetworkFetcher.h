//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseNetworkFetcher.h"


@interface GBRMyLibraryNetworkFetcher : GBRBaseNetworkFetcher

- (Promise *)loadAllBookshelves;    // Promise of NSArray<GBRBookshelf>

@end