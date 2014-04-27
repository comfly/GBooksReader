//
//  GBRStorage.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRStorage.h"
#import "GBRStorage+Protected.h"


@interface GBRStorage ()

@property (nonatomic, readonly) NSURL *networkCachesDirectoryURL;

@end

@implementation GBRStorage

- (instancetype)initWithUserName:(NSString *)userName {
    NSParameterAssert([userName length] > 0);

    self = [super init];
    if (self) {
        _networkCachesDirectoryURL = [[self class] cachesDirectoryURLForUserName:userName];

        NSError *error = [self createDirectoryIfNotExistsAtURL:self.networkCachesDirectoryURL];
        if (error) {
            DDLogError(@"Unable to create directory at URL %@: %@", self.networkCachesDirectoryURL, error);
            self = nil;
        }
    }

    return self;
}

- (NSError *)createDirectoryIfNotExistsAtURL:(NSURL *)URL {
    NSParameterAssert(URL);

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSAssert(fileManager, @"Must be successfully created");

    __autoreleasing NSError *error;
    if (![fileManager createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error]) {
        if ([[error domain] isEqualToString:NSCocoaErrorDomain] && [error code] == NSFileWriteFileExistsError) {
            // Directory exists. So it's essentially not an error. Ignore.
            error = nil;
        }
    }

    return error;
}

+ (NSURL *)cachesDirectoryURLForUserName:(NSString *)userName {
    return [[GBRConfiguration configuration].cachesDirectoryURL URLByAppendingPathComponent:userName isDirectory:YES];
}

@end