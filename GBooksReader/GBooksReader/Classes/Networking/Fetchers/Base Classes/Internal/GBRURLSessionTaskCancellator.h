//
// Created by Dmitry Zakharov on 5/20/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRCancellable.h"


@interface GBRURLSessionTaskCancellator : NSObject <GBRCancellable>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)task cancellationBlock:(void (^)(NSData *resumeData))cancellationBlock;

@end
