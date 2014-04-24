//
//  GBRTypes.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/23/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRTypes.h"
#import "GBRNumberFormatters.h"


id GBRBoxID(GBRID id) {
    return @(id);
}

GBRID GBRUnboxID(id id) {
    return [id unsignedLongLongValue];
}

NSString *NSStringFromGBRID(GBRID id) {
    return FORMAT(@"%llu", id);
}

GBRID GBRIDFromString(NSString *string) {
    return GBRUnboxID([[GBRNumberFormatters idFormatter] numberFromString:string]);
}
