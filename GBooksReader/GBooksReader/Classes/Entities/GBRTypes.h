//
//  GBRTypes.h
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/23/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;

typedef NS_ENUM(NSUInteger, GBRBookType) {
    GBRBookTypeUnknown,
    GBRBookTypePDF,
    GBRBookTypeEPUB
};

extern BOOL GBRIsBookTypeValid(GBRBookType);
extern NSString *GBRFileExtensionForType(GBRBookType);
extern GBRBookType GBRBookTypeFromString(NSString *string);

typedef NS_ENUM(NSUInteger, GBRProcessingState) {
    GBRProcessingStateFailed,       // "COMPLETED_FAILED"
    GBRProcessingStateSuccess,      // "COMPLETED_SUCCESS"
    GBRProcessingStateRunning       // "RUNNING"
};

typedef NS_ENUM(NSUInteger, GBRPrintType) {
    GBRPrintTypeNone,
    GBRPrintTypeAll = GBRPrintTypeNone, // "ALL"
    GBRPrintTypeBook,                   // "BOOK"
    GBRPrintTypeMagazine                // "MAGAZINE"
};

typedef NS_ENUM(NSUInteger, GBRRating) {
    GBRRatingNone,  // "NOT_RATED"
    GBRRatingOne,   // "ONE"
    GBRRatingTwo,   // "TWO"
    GBRRatingThree, // "THREE"
    GBRRatingFour,  // "FOUR"
    GBRRatingFive,  // "FIVE"
};
