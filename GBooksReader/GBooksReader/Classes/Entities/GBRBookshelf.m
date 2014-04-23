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
    self = [super init];
    if (self) {
        _id = id;
        _title = [title copy];
        _volumeCount = volumeCount;
        _volumesLastUpdated = volumesLastUpdated;
        _updatedAt = updatedAt;
        _createdAt = createdAt;
    }

    return self;
}

+ (instancetype)bookshelfWithID:(GBRID)id
                          title:(NSString *)title
                    volumeCount:(NSUInteger)volumeCount
             volumesLastUpdated:(NSDate *)volumesLastUpdated
                      updatedAt:(NSDate *)updatedAt
                      createdAt:(NSDate *)createdAt {
    return [[self alloc] initWithID:id
                              title:title
                        volumeCount:volumeCount
                 volumesLastUpdated:volumesLastUpdated
                          updatedAt:updatedAt
                          createdAt:createdAt];
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"createdAt": @"created",
        @"updatedAt": @"updated"
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

    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [timestampFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [timestampFormatter stringFromDate:date];
    }];
}

@end
