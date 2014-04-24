//
//  GBRAuthorizationViewController.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRAuthorizationViewController.h"
#import <GooglePlus/GPPSignInButton.h>
#import <CompactConstraint/CompactConstraint.h>


@implementation GBRAuthorizationViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

    GPPSignInButton *button = [self authenticationButton];
    [view addSubview:button];

    [view addCompactConstraints:@[
            @"button.centerY = super.centerY",
            @"button.centerX = super.centerX"
    ]                   metrics:nil views:NSDictionaryOfVariableBindings(button)];

    self.view = view;
}

- (GPPSignInButton *)authenticationButton {
    GPPSignInButton *result = [[GPPSignInButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [result setTranslatesAutoresizingMaskIntoConstraints:NO];

    return result;
}

@end
