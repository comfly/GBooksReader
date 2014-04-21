//
//  GBRAuthorizationViewController.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRAuthorizationViewController.h"
#import "GBRGoogleAuthorization.h"
#import <GooglePlus/GPPSignInButton.h>

@interface GBRAuthorizationViewController ()

@end

@implementation GBRAuthorizationViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.view = view;

    GPPSignInButton *button = [self authenticationButton];
    [view addSubview:button];

    NSLayoutConstraint *horizontalConstraints = [NSLayoutConstraint constraintWithItem:button
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:0.0];

    NSLayoutConstraint *verticalConstraints = [NSLayoutConstraint constraintWithItem:button
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:view
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0
                                                                            constant:0.0];

    [view addConstraints:@[ horizontalConstraints, verticalConstraints ]];
}

- (GPPSignInButton *)authenticationButton {
    GPPSignInButton *result = [[GPPSignInButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [result setTranslatesAutoresizingMaskIntoConstraints:NO];

    return result;
}

@end
