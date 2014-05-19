//
// Created by Dmitry Zakharov on 5/20/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBlockedIf.h"

@interface GBRBlockedIf ()

@property (nonatomic, readonly) BOOL predicate;

@end


@implementation GBRBlockedIf

- (instancetype)initWithPredicate:(BOOL)predicate {
    self = [super init];
    if (self) {
        _predicate = predicate;
    }

    return self;
}

+ (instancetype)if:(BOOL)predicateResult {
    return [[self alloc] initWithPredicate:predicateResult];
}

- (id)then:(id(^)(void))thenBlock {
    return self.predicate ? thenBlock() : nil;
}

- (id)then:(id(^)(void))thenBlock else:(id(^)(void))elseBlock {
    return self.predicate ? thenBlock() : elseBlock();
}

@end

GBRBlockedIf *GBRIf(BOOL predicate) {
    return [GBRBlockedIf if:predicate];
}

@implementation NSObject (GBRBlockedIf)

- (id)then:(id(^)(void))thenBlock {
    return self;
}

- (id)then:(id(^)(void))thenBlock else:(id(^)(void))elseBlock {
    return self;
}

@end
