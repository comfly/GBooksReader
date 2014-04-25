//
//  GBRIndustryIdentifier.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRIndustryIdentifier.h"


@implementation GBRIndustryIdentifier

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

- (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"ISBN_10" : @(GBRIndustryIdentifierISBN10),
        @"ISBN_13" : @(GBRIndustryIdentifierISBN13),
        @"ISSN"    : @(GBRIndustryIdentifierISSN),
        @"OTHER"   : @(GBRIndustryIdentifierOther)
    }];
}

@end