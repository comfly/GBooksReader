//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRMyUploadedBooksNetworkFetcher.h"
#import "GBRBaseDataFetcher+Protected.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRBook.h"
#import "GBRNetworkPaths.h"


@implementation GBRMyUploadedBooksNetworkFetcher

- (Promise *)loadMyUploadedBooks {
    __block NSURLSessionTask *task;
    Promise *promise = [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
        Class itemClass = [GBRBook class];

        @weakify(self);
        void(^successBlock)(NSURLSessionDataTask *, NSArray *) = ^(NSURLSessionDataTask *_, NSArray *books) {
            @strongify(self);
            if (books) {
                fulfiller([books gbr_compact]);
            } else {
                rejecter([self parsingErrorForClass:itemClass]);
            }
        };

        task = [self.manager GET:[GBRNetworkPaths pathToMyUploadedBooks]
                      parameters:nil
                      modelClass:itemClass
                         keyPath:@"items"
                         success:successBlock
                         failure:[self defaultNetworkErrorProcessingBlockWithRejecter:rejecter]];
    }];

    return [self registerCancellationBlock:^{ [task cancel]; } withPromise:promise];
}

- (NSError *)parsingErrorForClass:(Class)klass {
    NSString *message = FORMAT(@"Unable to parse %@ network response", NSStringFromClass(klass));
    return [NSError applicationErrorWithCode:GBRResponseParsingError message:message];
}

@end
