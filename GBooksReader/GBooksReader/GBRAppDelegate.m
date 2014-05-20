//
//  GBRAppDelegate.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/19/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRAppDelegate.h"
#import "GBRGoogleAuthorization.h"

@interface GBRAppDelegate () <GBRAuthorizationDelegate>

@end


@implementation GBRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (!IS_TEST_RUN) {
        [self setupApplication];
    }

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    if (IS_TEST_RUN) {
        self.window.rootViewController = [[UIViewController alloc] init];
    } else {
        id<GBRAuthorization> authorization = [[GBRGoogleAuthorization alloc] initWithDelegate:self];
        if ([authorization isAuthenticated] || [authorization trySilentAuthentication]) {
            self.window.rootViewController = [[UIViewController alloc] init];
        } else {
            self.window.rootViewController = [[[GBRGoogleAuthorization alloc] init] authorizationViewController];
        }
    }
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)setupApplication {
    ONCE(^{
        GBRSetupLogger();
    });
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[[GBRGoogleAuthorization alloc] init] handleAuthorizationURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)authorization:(id<GBRAuthorization>)authorization didFailAuthorizationWithError:(NSError *)error {

}

- (void)authorizationDidSuccessfullyAuthorized:(id<GBRAuthorization>)authorization {
    DDLogInfo(@"Token: %@", [authorization token]);
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {

}


@end
