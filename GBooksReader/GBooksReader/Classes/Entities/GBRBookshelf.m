//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBookshelf.h"
#import "GBRValueTransformers.h"


@implementation GBRBookshelf

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        SELECTOR_NAME(createdAt) : @"created",
        SELECTOR_NAME(updatedAt) : @"updated"
    };
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [GBRValueTransformers timestampValueTransformer];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [GBRValueTransformers timestampValueTransformer];
}

+ (NSValueTransformer *)volumesLastUpdatedJSONTransformer {
    return [GBRValueTransformers timestampValueTransformer];
}

@end
