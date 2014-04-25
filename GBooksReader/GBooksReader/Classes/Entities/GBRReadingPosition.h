//
//  GBRReadingPosition.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;


@interface GBRReadingPosition : MTLModel <MTLJSONSerializing>

// Position in an EPUB as a CFI.
@property (nonatomic, readonly, copy) NSString *EPUBCFIPosition;

// Position in a volume for image-based content.
@property (nonatomic, readonly, copy) NSString *imagePosition;

// Position in a volume for text-based content.
@property (nonatomic, readonly, copy) NSString *textPosition;

// Position in a PDF file.
@property (nonatomic, readonly, copy) NSString *PDFPosition;

@property (nonatomic, readonly, copy) NSDate *updatedAt;

@end