//
//  GBRIndustryIdentifier.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


typedef NS_ENUM(NSUInteger, GBRIndustryIdentifierType) {
    GBRIndustryIdentifierISBN10,
    GBRIndustryIdentifierISBN13,
    GBRIndustryIdentifierISSN,
    GBRIndustryIdentifierOther
};

@interface GBRIndustryIdentifier : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) GBRIndustryIdentifierType type;
@property (nonatomic, readonly, copy) NSString *identifier;

@end