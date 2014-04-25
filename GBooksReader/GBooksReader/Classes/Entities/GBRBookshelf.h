//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseEntity.h"


GENERICSABLE(GBRBookshelf)


@interface GBRBookshelf : GBRBaseEntity<MTLJSONSerializing, GBRBookshelf>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSUInteger volumeCount;
@property (nonatomic, readonly) NSDate *volumesLastUpdated;
@property (nonatomic, readonly) NSDate *updatedAt;
@property (nonatomic, readonly) NSDate *createdAt;

- (instancetype)initWithID:(GBRID)id NS_UNAVAILABLE;

- (instancetype)initWithID:(GBRID)id
                     title:(NSString *)title
               volumeCount:(NSUInteger)volumeCount
        volumesLastUpdated:(NSDate *)volumesLastUpdated
                 updatedAt:(NSDate *)updatedAt
                 createdAt:(NSDate *)createdAt;

@end
