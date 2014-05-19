//
// Created by Dmitry Zakharov on 5/20/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRURLSessionTaskCancellator.h"


@interface GBRURLSessionTaskCancellator ()

@property (nonatomic, readonly, weak) NSURLSessionDownloadTask *task;
@property (nonatomic, readonly, copy) void (^cancellationBlock)(NSData *);

@end

@implementation GBRURLSessionTaskCancellator

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)task cancellationBlock:(void (^)(NSData *resumeData))cancellationBlock {
    self = [super init];
    if (self) {
        _task = task;
        _cancellationBlock = [cancellationBlock copy];
    }

    return self;
}

- (void)cancel {
    [self.task cancelByProducingResumeData:self.cancellationBlock];
}

@end
