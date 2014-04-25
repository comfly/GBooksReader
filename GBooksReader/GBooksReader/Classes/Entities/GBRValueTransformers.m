//
//  GBRValueTransformers.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRValueTransformers.h"
#import "GBRDateFormatters.h"


@implementation GBRValueTransformers

+ (NSValueTransformer *)timestampValueTransformer {
    NSDateFormatter *timestampFormatter = [GBRDateFormatters timestampFormatter];

    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *string) {
        return [timestampFormatter dateFromString:string];
    } reverseBlock:^(NSDate *date) {
        return [timestampFormatter stringFromDate:date];
    }];
}

@end