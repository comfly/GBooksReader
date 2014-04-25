//
//  GBRThumbnailURLs.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRThumbnailURLs.h"


@implementation GBRThumbnailURLs

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([[NSSet setWithObjects:
            SELECTOR_NAME(smallThumbnail),
            SELECTOR_NAME(thumbnail),
            SELECTOR_NAME(small),
            SELECTOR_NAME(medium),
            SELECTOR_NAME(large),
            SELECTOR_NAME(extraLarge),
            nil
    ] containsObject:key]) {
        return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
    }

    return nil;
}

@end