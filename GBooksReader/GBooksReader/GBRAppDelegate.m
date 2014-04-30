//
//  GBRAppDelegate.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/19/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRAppDelegate.h"
#import "GBRAssembly.h"
#import "GBRGoogleAuthorization.h"

GBRAssembly *GBRObjectFactory = nil;

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
        id<GBRAuthorization> authorization = [GBRObjectFactory authorizer];
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
        GBRObjectFactory = [self setupDependencyInjector];
    });
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[[GBRGoogleAuthorization alloc] init] handleAuthorizationURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (GBRAssembly *)setupDependencyInjector {
    return (GBRAssembly *) (id) [TyphoonBlockComponentFactory factoryWithAssembly:[GBRAssembly assembly]];
}

- (void)authorization:(id<GBRAuthorization>)authorization didFailAuthorizationWithError:(NSError *)error {

}

- (void)authorizationDidSuccessfullyAuthorized:(id<GBRAuthorization>)authorization {
    DDLogInfo(@"Token: %@", [authorization token]);
}

@end
