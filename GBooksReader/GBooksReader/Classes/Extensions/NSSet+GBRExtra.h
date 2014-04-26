//
//  NSSet+GBRExtra.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@interface NSSet (GBRExtra)

- (instancetype)gbr_setMinusSet:(NSSet *)other;

@end