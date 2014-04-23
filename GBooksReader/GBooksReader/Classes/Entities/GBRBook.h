//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseEntity.h"


GENERICSABLE(GBRBook);


@interface GBRBook : GBRBaseEntity <GBRBook>

@property (nonatomic, readonly) GBRID id;

@end
