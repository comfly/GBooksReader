//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBaseEntity.h"


@implementation GBRBaseEntity

- (instancetype)initWithID:(GBRID)id {
    self = [super init];
    if (self) {
        _id = id;
    }

    return self;
}

@end
