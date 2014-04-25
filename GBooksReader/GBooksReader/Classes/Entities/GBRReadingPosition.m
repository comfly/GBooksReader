//
//  GBRReadingPosition.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRReadingPosition.h"
#import "GBRValueTransformers.h"


@implementation GBRReadingPosition

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        SELECTOR_NAME(EPUBCFIPosition) : @"epubCfiPosition",
        SELECTOR_NAME(imagePosition) : @"gbImagePosition",
        SELECTOR_NAME(textPosition) : @"gbTextPosition",
        SELECTOR_NAME(PDFPosition) : @"pdfPosition",
        SELECTOR_NAME(updatedAt) : @"updated",
    };
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [GBRValueTransformers timestampValueTransformer];
}

@end