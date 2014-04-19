//
//  GBRConfiguration.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRConfiguration.h"


@interface GBRConfiguration ()

@end

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
    _clientSecret = [defaults stringForKey:SELECTOR_NAME(clientSecret)];
    _redirectURI = [defaults stringForKey:SELECTOR_NAME(redirectURI)];
}

+ (instancetype)sharedInstance {
    static GBRConfiguration *instance;

    static dispatch_once_t token;
    dispatch_once(&token, ^{
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

@end