//
//  GBRTypes.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/23/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRTypes.h"

BOOL GBRIsBookTypeValid(GBRBookType type) {
    switch (type) {
        case GBRBookTypePDF:
        case GBRBookTypeEPUB:
            return YES;
        default:
            return NO;
    }
}

NSString *GBRFileExtensionForType(GBRBookType type) {
    NSCParameterAssert(GBRIsBookTypeValid(type));

    switch (type) {
        case GBRBookTypePDF:
            return @"pdf";
        case GBRBookTypeEPUB:
            return @"epub";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:FORMAT(@"Unknown type of Book: %u", type) userInfo:nil];
    }
}

GBRBookType GBRBookTypeFromString(NSString *string) {
    NSCParameterAssert([string length] > 0);

    return (GBRBookType) [@{
            @"pdf" : @(GBRBookTypePDF),
            @"epub" : @(GBRBookTypeEPUB)
    }[[string lowercaseString]] unsignedIntegerValue];
}
