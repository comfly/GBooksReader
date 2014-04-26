//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseEntity.h"


@class GBRThumbnailURLs;
@class GBRReadingPosition;

@interface GBRBook : GBRBaseEntity <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *id;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *synopsis;
/**
* NSArray of NSString *
*/
@property (nonatomic, readonly, copy) NSArray *authors;
@property (nonatomic, readonly, copy) NSString *publisher;
@property (nonatomic, readonly) NSDate *publishedDate;
@property (nonatomic, readonly) NSUInteger pageCount;
@property (nonatomic, readonly) GBRPrintType printType;
/**
* NSArray of NSString *
*/
@property (nonatomic, readonly, copy) NSArray *categories;
@property (nonatomic, readonly) GBRThumbnailURLs *imageLinks;
@property (nonatomic, readonly, copy) NSString *mainCategory;
@property (nonatomic, readonly) GBRRating rating;
@property (nonatomic, readonly) GBRReadingPosition *readingPosition;
@property (nonatomic, readonly) NSURL *EPUBDownloadLink;
@property (nonatomic, readonly) NSURL *EPUBACSTokenLink;
@property (nonatomic, readonly) NSURL *PDFDownloadLink;
@property (nonatomic, readonly) NSURL *PDFACSTokenLink;
@property (nonatomic, readonly) NSDate *updatedAt;
@property (nonatomic, readonly) GBRProcessingState status;

@end
