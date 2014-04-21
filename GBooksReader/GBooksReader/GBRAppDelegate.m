//
//  GBRAppDelegate.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/19/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRAppDelegate.h"
#import "GBRGoogleAuthorization.h"

@implementation GBRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupApplication];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[[GBRGoogleAuthorization alloc] init] authorizationViewController];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)setupApplication {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        GBRSetupLogger();
    });
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[[GBRGoogleAuthorization alloc] init] handleAuthorizationURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
