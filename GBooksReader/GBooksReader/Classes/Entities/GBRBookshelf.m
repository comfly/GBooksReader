//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBookshelf.h"
#import "GBRDateFormatters.h"


@implementation GBRBookshelf

- (instancetype)initWithID:(GBRID)id
                     title:(NSString *)title
               volumeCount:(NSUInteger)volumeCount
        volumesLastUpdated:(NSDate *)volumesLastUpdated
                 updatedAt:(NSDate *)updatedAt
                 createdAt:(NSDate *)createdAt {
    self = [super initWithID:id];
    if (self) {
        _title = [title copy];
        _volumeCount = volumeCount;
        _volumesLastUpdated = volumesLastUpdated;
        _updatedAt = updatedAt;
        _createdAt = createdAt;
    }

    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"createdAt" : @"created",
        @"updatedAt" : @"updated"
    };
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [self timestampValueTransformer];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [self timestampValueTransformer];
}

+ (NSValueTransformer *)volumesLastUpdatedJSONTransformer {
    return [self timestampValueTransformer];
}

+ (NSValueTransformer *)timestampValueTransformer {
    NSDateFormatter *timestampFormatter = [GBRDateFormatters timestampFormatter];

    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *string) {
        return [timestampFormatter dateFromString:string];
    } reverseBlock:^(NSDate *date) {
        return [timestampFormatter stringFromDate:date];
    }];
}

@end
