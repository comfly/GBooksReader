//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


@interface GBRBaseEntity : MTLModel

@property (nonatomic, readonly) GBRID id;

- (instancetype)initWithID:(GBRID)id;

@end
