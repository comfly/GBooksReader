//
//  NSArray+GBRExtra.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@implementation NSArray (GBRExtra)

- (NSArray *)compact {
    return [self bk_reject:^BOOL(id item) {
        return item == [NSNull null];
    }];
}

@end
