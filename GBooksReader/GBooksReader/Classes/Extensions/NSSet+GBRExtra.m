//
//  NSSet+GBRExtra.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "NSSet+GBRExtra.h"


@implementation NSSet (GBRExtra)

- (instancetype)gbr_setMinusSet:(NSSet *)other {
    NSMutableSet *this = [self mutableCopy];
    [this minusSet:other];
    return [this copy];
}

@end