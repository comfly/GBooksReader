//
//  GBRConfiguration.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRConfiguration.h"


@implementation GBRConfiguration

- (instancetype)initInternal {
    self = [super init];
    if (self) {
        [self load];
    }

    return self;
}

- (void)load {
    NSUserDefaults *defaults = [self defaults];
    [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfURL:[self configurationFileURL]]];

    _clientID = [defaults stringForKey:SELECTOR_NAME(clientID)];
    _baseURL = [NSURL URLWithString:[defaults objectForKey:SELECTOR_NAME(baseURL)]];
    _booksScope = [defaults stringForKey:SELECTOR_NAME(booksScope)];
}

+ (instancetype)configuration {
    static GBRConfiguration *instance;

    ONCE(^{
        instance = [[self alloc] initInternal];
    });

    return instance;
}

- (NSUserDefaults *)defaults {
    return [NSUserDefaults standardUserDefaults];
}

- (NSURL *)configurationFileURL {
    return [[NSBundle mainBundle] URLForResource:@"configuration" withExtension:@"plist"];
}

- (BOOL)isTestRun {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"com.comfly.GBooksReader.TestRun"];
}

- (NSURL *)directoryAppendedWithAppNameForType:(NSSearchPathDirectory)type {
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:type inDomains:NSUserDomainMask] firstObject];
    return [directoryURL URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier] isDirectory:YES];
}

- (NSURL *)cachesDirectoryURL {
    static NSURL *folderURL;

    ONCE(^{
        folderURL = [self directoryAppendedWithAppNameForType:NSCachesDirectory];
    });

    return folderURL;
}

- (NSURL *)applicationSupportDirectoryURL {
    static NSURL *folderURL;

    ONCE(^{
        folderURL = [self directoryAppendedWithAppNameForType:NSApplicationSupportDirectory];
    });

    return folderURL;
}

@end
