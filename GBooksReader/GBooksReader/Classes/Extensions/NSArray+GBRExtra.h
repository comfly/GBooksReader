//
//  NSArray+GBRExtra.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;

@interface NSArray (GBRExtra)

- (NSArray *)gbr_compact;

typedef id<NSCopying> (^GBRKeyGeneratorBlock)(id);
- (NSDictionary *)gbr_dictionaryWithKeyBlock:(GBRKeyGeneratorBlock)keyBlock valueBlock:(id (^)(id))valueBlock;
- (NSDictionary *)gbr_dictionaryWithKeyBlock:(GBRKeyGeneratorBlock)keyBlock;

@end
