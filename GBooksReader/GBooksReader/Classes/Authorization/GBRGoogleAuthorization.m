//
//  GBRGoogleAuthorization.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRGoogleAuthorization.h"
#import "GBRConfiguration.h"
#import <GoogleOpenSource/GTMOAuth2Authentication.h>
#import <GooglePlus/GPPSignInButton.h>
#import <GooglePlus/GPPSignIn.h>


@interface GBRGoogleAuthorization () <GPPSignInDelegate>

@end

@implementation GBRGoogleAuthorization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureSignIn:[GPPSignIn sharedInstance] withDelegate:self];
    }

    return self;
}

- (GPPSignIn *)configureSignIn:(GPPSignIn *)signIn withDelegate:(id<GPPSignInDelegate>)delegate {
    NSParameterAssert(signIn);

    signIn.clientID = [self clientID];
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.scopes = [self scopes];
    signIn.delegate = delegate;

    return signIn;
}

- (NSString *)clientID {
    return [GBRConfiguration sharedInstance].clientID;
}

- (NSArray *)scopes {
    return @[ @"https://www.google.com/books/feeds/" ];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {

}

- (GPPSignInButton *)authenticationButtonAtCenterPoint:(CGPoint)center {
    GPPSignInButton *result = [[GPPSignInButton alloc] init];
    result.center = center;
    
    return result;
}

@end