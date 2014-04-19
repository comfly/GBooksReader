//
//  GBRGoogleAuthorization.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@class GPPSignInButton;

@interface GBRGoogleAuthorization : NSObject

- (GPPSignInButton *)authenticationButtonAtCenterPoint:(CGPoint)center;

@end