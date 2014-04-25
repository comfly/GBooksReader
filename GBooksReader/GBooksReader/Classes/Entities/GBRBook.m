//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRBook.h"
#import "GBRThumbnailURLs.h"
#import "GBRIndustryIdentifier.h"
#import "GBRReadingPosition.h"
#import "GBRValueTransformers.h"


@implementation GBRBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        SELECTOR_NAME(title) : @"volumeInfo.title",
        SELECTOR_NAME(subtitle) : @"volumeInfo.subtitle",
        SELECTOR_NAME(synopsis) : @"volumeInfo.description",
        SELECTOR_NAME(authors) : @"volumeInfo.authors",
        SELECTOR_NAME(publisher) : @"volumeInfo.publisher",
        SELECTOR_NAME(publishedDate) : @"volumeInfo.publishedDate",
        SELECTOR_NAME(identifiers) : @"volumeInfo.industryIdentifiers",
        SELECTOR_NAME(pageCount) : @"volumeInfo.pageCount",
        SELECTOR_NAME(printType) : @"volumeInfo.printType",
        SELECTOR_NAME(categories) : @"volumeInfo.categories",
        SELECTOR_NAME(mainCategory) : @"volumeInfo.mainCategory",
        SELECTOR_NAME(contentVersion) : @"volumeInfo.contentVersion",
        SELECTOR_NAME(imageLinks) : @"volumeInfo.imageLinks",
        SELECTOR_NAME(canonicalVolumeLink) : @"volumeInfo.canonicalVolumeLink",
        SELECTOR_NAME(rating) : @"userInfo.review.rating",
        SELECTOR_NAME(readingPosition) : @"userInfo.readingPosition",
        SELECTOR_NAME(status) : @"userInfo.userUploadedVolumeInfo.processingState",
        SELECTOR_NAME(updatedAt) : @"userInfo.updated",
        SELECTOR_NAME(EPUBDownloadLink) : @"accessInfo.epub.downloadLink",
        SELECTOR_NAME(EPUBACSTokenLink) : @"accessInfo.epub.acsTokenLink",
        SELECTOR_NAME(PDFDownloadLink) : @"accessInfo.pdf.downloadLink",
        SELECTOR_NAME(PDFACSTokenLink) : @"accessInfo.pdf.acsTokenLink"
    };
}

- (NSValueTransformer *)publishedDateJSONTransformer {
    return [GBRValueTransformers timestampValueTransformer];
}

- (NSValueTransformer *)industryIdentifiersJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GBRIndustryIdentifier class]];
}

- (NSValueTransformer *)printTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"all" : @(GBRPrintTypeAll),
        @"books" : @(GBRPrintTypeBooks),
        @"magazines" : @(GBRPrintTypeMagazines)
    }];
}

- (NSValueTransformer *)imageLinksJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[GBRThumbnailURLs class]];
}

- (NSValueTransformer *)ratingJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"NOT_RATED" : @(GBRRatingNone),
        @"ONE" : @(GBRRatingOne),
        @"TWO" : @(GBRRatingTwo),
        @"THREE" : @(GBRRatingThree),
        @"FOUR" : @(GBRRatingFour),
        @"FIVE" : @(GBRRatingFive)
    }];
}

- (NSValueTransformer *)readingPositionJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[GBRReadingPosition class]];
}

- (NSValueTransformer *)processingStateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"COMPLETED_FAILED" : @(GBRProcessingStateFailed),
        @"COMPLETED_SUCCESS" : @(GBRProcessingStateSuccess),
        @"RUNNING" : @(GBRProcessingStateRunning),
    }];
}

- (NSValueTransformer *)updatedAtJSONTransformer {
    return [GBRValueTransformers timestampValueTransformer];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([[NSSet setWithObjects:
            SELECTOR_NAME(EPUBDownloadLink),
            SELECTOR_NAME(EPUBACSTokenLink),
            SELECTOR_NAME(PDFDownloadLink),
            SELECTOR_NAME(PDFACSTokenLink),
            nil
    ] containsObject:key]) {
        return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
    }

    return nil;
}

@end
