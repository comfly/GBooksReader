//
//  GBRNumberFormatters.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRNumberFormatters.h"


@implementation GBRNumberFormatters

+ (NSNumberFormatter *)idFormatter {
    static NSNumberFormatter *formatter = nil;

    ONCE(^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setNumberStyle:NSNumberFormatterNoStyle];
        [formatter setGeneratesDecimalNumbers:NO];
        [formatter setUsesGroupingSeparator:NO];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setAllowsFloats:NO];
    });

    return formatter;
}

@end