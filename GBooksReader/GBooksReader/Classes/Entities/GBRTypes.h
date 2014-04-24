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
