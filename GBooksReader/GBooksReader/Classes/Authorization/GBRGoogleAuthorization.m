//
//  GBRGoogleAuthorization.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRGoogleAuthorization.h"
#import "GBRAuthorizationViewController.h"
#import <GoogleOpenSource/GTMOAuth2Authentication.h>
#import <GooglePlus/GPPURLHandler.h>
#import <GooglePlus/GPPSignIn.h>


@interface GBRGoogleAuthorization () <GPPSignInDelegate>

@property (nonatomic, readonly) GPPSignIn *signIn;
@property (nonatomic, readonly, weak) id<GBRAuthorizationDelegate> delegate;

@end

@implementation GBRGoogleAuthorization

- (instancetype)init {
    return (self = [self initWithDelegate:nil]);
}

- (instancetype)initWithDelegate:(id<GBRAuthorizationDelegate>)delegate {
    self = [super init];
    if (self) {
        _signIn = [self configureSign];
        _delegate = delegate;
    }

    return self;
}

- (GPPSignIn *)configureSign {
    GPPSignIn *result = [GPPSignIn sharedInstance];

    result.clientID = [self clientID];
    result.shouldFetchGoogleUserEmail = YES;
    result.scopes = [self scopes];
    result.delegate = self;

    return result;
}

- (NSString *)clientID {
    return [GBRConfiguration configuration].clientID;
}

- (NSArray *)scopes {
    return @[ [GBRConfiguration configuration].booksScope ];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    __typeof__(self.delegate) delegate = self.delegate;
    if (error) {
        DDLogError(@"Unable to login: %@", error);

        if ([delegate respondsToSelector:@selector(authorization:didFailAuthorizationWithError:)]) {
            [delegate authorization:self didFailAuthorizationWithError:error];
        }
    } else {
        [delegate authorizationDidSuccessfullyAuthorized:self];
    }
}

- (UIViewController *)authorizationViewController {
    return [[GBRAuthorizationViewController alloc] init];
}

- (BOOL)handleAuthorizationURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [GPPURLHandler handleURL:URL sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)isAuthenticated {
    return self.signIn.authentication != nil;
}

- (BOOL)trySilentAuthentication {
    return [self.signIn trySilentAuthentication];
}

- (NSString *)token {
    return self.signIn.authentication.accessToken;
}

- (NSString *)userEmail {
    return self.signIn.authentication.userEmail;
}

@end
