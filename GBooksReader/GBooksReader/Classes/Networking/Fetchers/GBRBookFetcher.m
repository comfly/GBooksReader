//
// Created by Dmitry Zakharov on 4/29/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBookFetcher.h"
#import "GBRBaseFileFetcher+Protected.h"
#import "GBRURLSessionTaskCancellator.h"


@interface GBRBookFetcher ()

@property (nonatomic, getter=isExecuted) BOOL executed;

@property (nonatomic, readonly, copy) NSString *bookID;
@property (nonatomic, readonly) GBRBookType type;

@property (nonatomic, readonly) AFURLSessionManager *manager;

@end

@implementation GBRBookFetcher

- (NSData *)resumeDataForBookWithID:(NSString *)bookID type:(GBRBookType)type {
    NSURL *fileURL = [self resumeDataFileURLForBookID:bookID type:type];

    __autoreleasing NSError *error;
    NSData *resumeData = [NSData dataWithContentsOfURL:fileURL options:0 error:&error];
    if (error) {
        DDLogError(@"Error reading resume data file %@: %@", fileURL, error);
    }

    return resumeData;
}

- (void)storeResumeData:(NSData *)data forBookWithID:(NSString *)bookID type:(GBRBookType)type {
    NSParameterAssert(data);

    NSURL *fileURL = [self resumeDataFileURLForBookID:bookID type:type];

    __autoreleasing NSError *error;
    if (![data writeToURL:fileURL options:NSDataWritingAtomic | NSDataWritingFileProtectionNone error:&error]) {
        DDLogError(@"Error writing resume data in file %@: %@", fileURL, error);
    }
}

- (void)destroyResumeDataForBookWithID:(NSString *)bookID type:(GBRBookType)type {
    NSURL *fileURL = [self resumeDataFileURLForBookID:bookID type:type];
    __autoreleasing NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    if (error && !([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorFileDoesNotExist)) {
        DDLogError(@"Unable to remove resume file at URL: %@", fileURL);
    }
}

+ (NSURL *)buildDestinationURLForBookWithID:(NSString *)ID type:(GBRBookType)type {
    NSString *filePath = [ID stringByAppendingPathExtension:[self extensionForType:type]];
    return [[self booksDownloadDirectory] URLByAppendingPathComponent:filePath isDirectory:NO];
}

+ (NSString *)extensionForType:(GBRBookType)bookType {
    return GBRFileExtensionForType(bookType);
}

+ (NSURL *)booksDownloadDirectory {
    return [[GBRConfiguration configuration].applicationSupportDirectoryURL URLByAppendingPathComponent:@"books" isDirectory:YES];
}

- (NSURL *)resumeDataFileURLForBookID:(NSString *)bookID type:(GBRBookType)type {
    NSURL *directory = [[GBRConfiguration configuration].applicationSupportDirectoryURL URLByAppendingPathComponent:@"downloads" isDirectory:YES];
    NSString *fileName = FORMAT(@"%@.%@.data", bookID, GBRFileExtensionForType(type));
    return [directory URLByAppendingPathComponent:fileName isDirectory:NO];
}

- (instancetype)initWithBookID:(NSString *)bookID type:(GBRBookType)type URL:(NSURL *)URL token:(NSString *)token {
    NSParameterAssert([bookID length] > 0);
    NSParameterAssert(URL);
    NSParameterAssert([token length] > 0);

    self = [super initWithUniqueIdentifier:[[self class] buildUniqueIdentifierWithBookID:bookID type:type] token:token URL:URL];
    if (self) {
        _bookID = [bookID copy];
        _type = type;
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[[self class] sessionConfigurationWithIdentifier:self.uniqueIdentifier]];
    }

    return self;
}

+ (void)completeBackgroundLoadingWithSessionIdentifier:(NSString *)sessionID backgroundDownloadCompletionHandler:(void (^)(void))backgroundDownloadCompletionHandler completionHandler:(void (^)(NSString *bookID, GBRBookType type, NSURL *fileURL))completionHandler {
    NSParameterAssert([sessionID length] > 0);
    NSParameterAssert(backgroundDownloadCompletionHandler);
    NSParameterAssert(completionHandler);

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[self sessionConfigurationWithIdentifier:sessionID]];
    @weakify(self);
    [manager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        @strongify(self);

        NSString *bookID = [self bookIDFromSessionID:sessionID];
        GBRBookType bookType = [self bookTypeFromSessionID:sessionID];
        NSURL *fileURL = [self buildDestinationURLForBookWithID:bookID type:bookType];

        completionHandler(bookID, bookType, fileURL);
        [self destroyResumeDataForBookWithID:bookID type:bookType];
        backgroundDownloadCompletionHandler();
    }];
}

+ (GBRBookType)bookTypeFromSessionID:(NSString *)sessionID {
    NSString *bookTypePart = [[sessionID componentsSeparatedByString:@"."] lastObject];
    return GBRBookTypeFromString(bookTypePart);
}

+ (NSString *)bookIDFromSessionID:(NSString *)sessionID {
    NSArray *parts = [sessionID componentsSeparatedByString:@"."];
    return parts[[parts count] - 2];
}

+ (NSString *)buildUniqueIdentifierWithBookID:(NSString *)bookID type:(GBRBookType)type {
    return FORMAT(@"com.comfly.GBooksReader.BookDownload.%@.%@", bookID, GBRFileExtensionForType(type));
}

+ (NSURLSessionConfiguration *)sessionConfigurationWithIdentifier:(NSString *)identifier {
    return [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return self.manager.session.configuration;
}

- (id<GBRCancellable>)loadBookWithProgress:(NSProgress * __autoreleasing *)progress completionBlock:(void (^)(NSURL *fileLocation, NSError *error))completionBlock {
    NSParameterAssert(completionBlock);

    NSAssert(!self.executed, @"The method can be called only once");
    self.executed = YES;

    NSString *bookID = self.bookID;
    GBRBookType bookType = self.type;

    @weakify(self);
    NSURL *(^destinationBlock)(NSURL *, NSURLResponse *) = ^(NSURL *targetPath, NSURLResponse *_) {
        @strongify(self);
        return [[self class] buildDestinationURLForBookWithID:bookID type:bookType];
    };
    void (^completionHandler)(NSURLResponse *, NSURL *, NSError *) = ^(NSURLResponse *_, NSURL *filePath, NSError *error) {
        @strongify(self);
        if (!error) {
            [self destroyResumeDataForBookWithID:bookID type:bookType];
        }

        completionBlock(filePath, error);
    };

    NSData *resumeData = [self resumeDataForBookWithID:bookID type:bookType];
    NSURLSessionDownloadTask *task = resumeData
            ? [self.manager downloadTaskWithResumeData:resumeData progress:progress destination:destinationBlock completionHandler:completionHandler]
            : [self.manager downloadTaskWithRequest:[self request] progress:progress destination:destinationBlock completionHandler:completionHandler];
    [task resume];

    return [[GBRURLSessionTaskCancellator alloc] initWithDownloadTask:task cancellationBlock:^(NSData *newResumeData) {
        [self storeResumeData:newResumeData forBookWithID:bookID type:bookType];
    }];
}

@end
