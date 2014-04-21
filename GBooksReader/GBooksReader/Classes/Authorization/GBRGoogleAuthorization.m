//
//  GBRGoogleAuthorization.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRGoogleAuthorization.h"
#import "GBRConfiguration.h"
#import "GBRAuthorizationViewController.h"
#import <GoogleOpenSource/GTMOAuth2Authentication.h>
#import <GooglePlus/GPPURLHandler.h>
#import <GooglePlus/GPPSignIn.h>


@interface GBRGoogleAuthorization () <GPPSignInDelegate>

@property (nonatomic, readonly) GPPSignIn *signIn;

@end

@implementation GBRGoogleAuthorization

- (instancetype)init {
    self = [super init];
    if (self) {
        _signIn = [self configureSignInWithDelegate:self];
    }

    return self;
}

- (GPPSignIn *)configureSignInWithDelegate:(id<GPPSignInDelegate>)delegate {
    GPPSignIn *result = [GPPSignIn sharedInstance];

    result.clientID = [self clientID];
    result.shouldFetchGoogleUserEmail = YES;
    result.scopes = [self scopes];
    result.delegate = delegate;

    return result;
}

- (NSString *)clientID {
    return [GBRConfiguration sharedInstance].clientID;
}

- (NSArray *)scopes {
    return @[ @"https://www.google.com/books/feeds/" ];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {

    } else if (auth) {

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

- (NSString *)token {
    return self.signIn.authentication.accessToken;
}

- (NSString *)userEmail {
    return self.signIn.authentication.userEmail;
}

@end
