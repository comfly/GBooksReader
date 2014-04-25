//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseEntity.h"


GENERICSABLE(GBRBook);


@interface GBRBook : GBRBaseEntity <GBRBook>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *publisher;
@property (nonatomic, readonly, copy) NSString *contentVersion;
@property (nonatomic, readonly) NSURL *smallThumbnail;
@property (nonatomic, readonly) NSURL *thumbnail;
@property (nonatomic, readonly) NSURL *previewLink;
@property (nonatomic, readonly) NSURL *infoLink;
@property (nonatomic, readonly) NSURL *canonicalVolumeLink;

@property (nonatomic, readonly) NSDate *updatedAt;
@property (nonatomic, readonly) GBRProcessingState processingState;

@end
