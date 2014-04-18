//
//  GBRAppDelegate.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/19/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRAppDelegate.h"

@implementation GBRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupApplication];

    return YES;
}

- (void)setupApplication {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        GBRSetupLogger();
    });
}

@end
