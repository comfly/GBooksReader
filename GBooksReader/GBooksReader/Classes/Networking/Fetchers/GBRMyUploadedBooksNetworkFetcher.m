//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRMyUploadedBooksNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRBook.h"
#import "GBRNetworkPaths.h"


@implementation GBRMyUploadedBooksNetworkFetcher

- (Promise *)loadMyUploadedBooks {
    Deferred *deferred = [[Deferred alloc] init];
    Class itemClass = [GBRBook class];

    @weakify(self);
    return [self initiateTask:[self.manager GET:[GBRNetworkPaths pathToMyUploadedBooks]
                                     parameters:nil
                                     modelClass:itemClass
                                        keyPath:@"items"
                                        success:^(NSURLSessionDataTask *_, NSArray *books) {
        @strongify(self);
        if (books) {
            [deferred resolve:[books gbr_compact]];
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
