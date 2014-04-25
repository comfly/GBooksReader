//
//  GBRTypes.h
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/23/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


typedef UInt64 GBRID;

extern id GBRBoxID(GBRID);
extern GBRID GBRUnboxID(id);
extern NSString *NSStringFromGBRID(GBRID);
extern GBRID GBRIDFromString(NSString *);

typedef NS_ENUM(NSUInteger, GBRProcessingState) {
    GBRProcessingStateFailed,       // "COMPLETED_FAILED"
    GBRProcessingStateSuccess,      // "COMPLETED_SUCCESS"
    GBRProcessingStateRunning       // "RUNNING"
};

typedef NS_ENUM(NSUInteger, GBRPrintType) {
    GBRPrintTypeAll,        // "all"
    GBRPrintTypeBooks,      // "books"
    GBRPrintTypeMagazines   // "magazines"
};

typedef NS_ENUM(NSUInteger, GBRRating) {
    GBRRatingNone,  // "NOT_RATED"
    GBRRatingOne,   // "ONE"
    GBRRatingTwo,   // "TWO"
    GBRRatingThree, // "THREE"
    GBRRatingFour,  // "FOUR"
    GBRRatingFive,  // "FIVE"
};