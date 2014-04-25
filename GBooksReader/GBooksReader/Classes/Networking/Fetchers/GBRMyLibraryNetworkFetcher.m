//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRMyLibraryNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRBookshelf.h"
#import "GBRBook.h"
#import "GBRNetworkPaths.h"


@implementation GBRMyLibraryNetworkFetcher

- (Promise *)loadAllBookshelves {
    Deferred *deferred = [[Deferred alloc] init];
    Class itemClass = [GBRBookshelf class];

    @weakify(self);
    return [self initiateTask:[self.manager GET:[GBRNetworkPaths pathToMyLibraryBookshelves]
                                     parameters:nil
                                     modelClass:itemClass
                                        keyPath:@"items"
                                        success:^(NSURLSessionDataTask *_, NSArray OF_TYPE(GBRBookshelf) *bookshelves) {
        @strongify(self);

        if (bookshelves) {
            [deferred resolve:[bookshelves compact]];
        } else {
            [self rejectDeferred:deferred withParsingErrorForClass:itemClass];
        }
    } failure:[self defaultNetworkErrorProcessingBlockWithDeferred:deferred]] forPromise:deferred.promise];
}

- (Promise *)loadBooksFromUploadedBookshelf {
    Deferred *deferred = [[Deferred alloc] init];
    Class itemClass = [GBRBook class];

    @weakify(self);
    return [self initiateTask:[self.manager GET:[GBRNetworkPaths pathToMyLibraryVolumesOnUploadedBookshelf]
                                     parameters:nil
                                     modelClass:itemClass
                                        keyPath:@"items"
                                        success:^(NSURLSessionDataTask *_, NSArray OF_TYPE(GBRBooks) *books) {
        @strongify(self);
        if (books) {
            [deferred resolve:[books compact]];
        } else {
            [self rejectDeferred:deferred withParsingErrorForClass:itemClass];
        }
    } failure:[self defaultNetworkErrorProcessingBlockWithDeferred:deferred]] forPromise:deferred.promise];
}

- (void)rejectDeferred:(Deferred *)deferred withParsingErrorForClass:(Class)class {
    NSString *message = FORMAT(@"Unable to parse %@ network response", NSStringFromClass(class));
    [deferred reject:[NSError applicationErrorWithCode:GBRResponseParsingError message:message]];
}

@end
