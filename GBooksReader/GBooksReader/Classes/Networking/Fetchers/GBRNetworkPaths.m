//
//  GBRNetworkPaths.c
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/24/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRNetworkPaths.h"

@implementation GBRNetworkPaths

+ (NSString *)pathToMyLibraryBookshelves {
    return @"mylibrary/bookshelves";
}

+ (NSString *)pathToMyLibraryVolumesOnUploadedBookshelf {
    return @"volumes/useruploaded";
}

@end
