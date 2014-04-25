//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseEntity.h"


@interface GBRBookshelf : GBRBaseEntity <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSUInteger volumeCount;
@property (nonatomic, readonly) NSDate *volumesLastUpdated;
@property (nonatomic, readonly) NSDate *updatedAt;
@property (nonatomic, readonly) NSDate *createdAt;

@end
