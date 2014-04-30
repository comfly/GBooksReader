//
// Created by Dmitry Zakharov on 4/29/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBookFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"


@interface GBRBookFetcher ()

@property (nonatomic, readonly) NSURL *downloadDirectory;

@end

@implementation GBRBookFetcher

- (instancetype)initWithBooksDownloadDirectory:(NSURL *)downloadDirectory {
    NSParameterAssert(downloadDirectory);

    self = [super init];
    if (self) {
        _downloadDirectory = downloadDirectory;
    }

    return self;
}

- (Promise *)loadBookWithID:(NSString *)ID
                      byURL:(NSURL *)URL
                     ofType:(GBRBookType)type
                   progress:(NSProgress * __autoreleasing *)progress
       cancellationCallback:(void (^)(NSData *))cancellationCallback {
    NSParameterAssert([ID length] > 0);
    NSParameterAssert(URL);
    NSParameterAssert(GBRIsBookTypeValid(type));

    __block NSURLSessionDownloadTask *task;
    Promise *promise = [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
        void (^completionHandler)(NSURLResponse *, NSURL *, NSError *) = ^(NSURLResponse *_, NSURL *filePath, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(filePath);
            }
        };

        @weakify(self);
        NSURL *(^destination)(NSURL *, NSURLResponse *) = ^(NSURL *proposedURL, NSURLResponse *_) {
            @strongify(self);
            return [self buildDestinationURLForBookWithID:ID proposedURL:proposedURL type:type];
        };

        task = [self.manager downloadTaskWithRequest:[self buildDownloadRequestWithURL:URL]
                                            progress:progress
                                         destination:destination
                                   completionHandler:completionHandler];
    }];

    return [self registerCancellationBlock:^{ [task cancelByProducingResumeData:cancellationCallback]; } withPromise:promise];
}

- (NSURL *)buildDestinationURLForBookWithID:(NSString *)ID proposedURL:(NSURL *)proposedURL type:(GBRBookType)type {
    NSString *filePath = [proposedURL path] ?: [ID stringByAppendingPathExtension:[self extensionForType:type]];
    return [self.downloadDirectory URLByAppendingPathComponent:filePath isDirectory:NO];
}

- (NSURLRequest *)buildDownloadRequestWithURL:(NSURL *)url {
    return [NSURLRequest requestWithURL:url];
}

- (NSString *)extensionForType:(GBRBookType)bookType {
    return GBRFileExtensionForType(bookType);
}

- (void (^)(NSData *))cancellationBlockForBookWithID:(NSString *)ID {
    return ^(NSData *data) {

    };
}

@end
