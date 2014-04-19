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

- (void)viewDidLoad {
    [super viewDidLoad];
    GPPSignInButton *button = [[[GBRGoogleAuthorization alloc] init] authenticationButtonAtCenterPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    [self.view addSubview:button];
}

@end