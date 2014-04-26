//
//  NSArray+GBRExtra.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@implementation NSArray (GBRExtra)

- (NSArray *)gbr_compact {
    return [self bk_reject:^BOOL(id item) {
        return item == [NSNull null];
    }];
}

- (NSDictionary *)gbr_dictionaryWithKeyBlock:(GBRKeyGeneratorBlock)keyBlock valueBlock:(id (^)(id))valueBlock {
    NSParameterAssert(keyBlock);
    NSParameterAssert(valueBlock);

    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    for (id item in self) {
        result[keyBlock(item)] = valueBlock(item);
    }

    return [result copy];
}

- (NSDictionary *)gbr_dictionaryWithKeyBlock:(GBRKeyGeneratorBlock)keyBlock {
    return [self gbr_dictionaryWithKeyBlock:keyBlock valueBlock:^(id _) { return _; }];
}

@end
