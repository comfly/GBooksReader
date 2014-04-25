//
//  GBRThumbnailURLs.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/26/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


@import Foundation;
#import "GBRBaseEntity.h"


@interface GBRThumbnailURLs : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSURL *smallThumbnail;
@property (nonatomic, readonly) NSURL *thumbnail;
@property (nonatomic, readonly) NSURL *small;
@property (nonatomic, readonly) NSURL *medium;
@property (nonatomic, readonly) NSURL *large;
@property (nonatomic, readonly) NSURL *extraLarge;

@end