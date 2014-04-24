//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRMyLibraryNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRBookshelf.h"
#import "GBRBook.h"


@implementation GBRMyLibraryNetworkFetcher

- (Promise *)loadAllBookshelves {
    Deferred *deferred = [[Deferred alloc] init];

    @weakify(self);
    return [self initiateTask:[self.manager GET:@"mylibrary/bookshelves" parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        @strongify(self);

        Class bookshelfClass = [GBRBookshelf class];

        NSArray *items = responseObject[@"items"];
        if (items) {
            NSArray *result = [[items bk_map:^GBRBookshelf *(NSDictionary *bookshelfDictionary) {
                __autoreleasing NSError *error;
                GBRBookshelf *bookshelf = [MTLJSONAdapter modelOfClass:bookshelfClass fromJSONDictionary:bookshelfDictionary error:&error];
                if (error) {
                    DDLogCError(@"Error parsing Bookshelf item: %@", error);
                    return nil;
                }
                return bookshelf;
            }] bk_reject:^BOOL(id item) {
                return item == [NSNull null];
            }];
            if ([result count] == 0 && [items count] > 0) {
                // All items are gone because of error.
                [self rejectDeferred:deferred withParsingErrorForClass:bookshelfClass];
            } else {
                [deferred resolve:result];
            }
        } else {
            [self rejectDeferred:deferred withParsingErrorForClass:bookshelfClass];
        }
    } failure:[self defaultNetworkErrorProcessingBlockWithDeferred:deferred]] forPromise:deferred.promise];
}

- (Promise *)loadBooksFromBookshelfWithID:(GBRID)bookselfID {
    Deferred *deferred = [[Deferred alloc] init];

    NSString *path = FORMAT(@"mylibrary/bookshelves/%@/volumes", @(bookselfID));

    @weakify(self);
    return [self initiateTask:[self.manager GET:path parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        @strongify(self);

        Class bookClass = [GBRBook class];

        NSArray *items = responseObject[@"items"];
        if (items) {

        } else {
            [self rejectDeferred:deferred withParsingErrorForClass:bookClass];
        }
    } failure:[self defaultNetworkErrorProcessingBlockWithDeferred:deferred]] forPromise:deferred.promise];
}

- (void)rejectDeferred:(Deferred *)deferred withParsingErrorForClass:(Class)class {
    NSString *message = FORMAT(@"Unable to parse %@ network response", NSStringFromClass(class));
    [deferred reject:[NSError applicationErrorWithCode:GBRResponseParsingError message:message]];
}

@end
