//
// Created by Dmitry Zakharov on 4/29/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseNetworkFetcher.h"


@interface GBRBookFetcher : GBRBaseNetworkFetcher

- (instancetype)initWithToken:(NSString *)token booksDownloadDirectory:(NSURL *)downloadDirectory;

- (Promise *)loadBookWithID:(NSString *)ID byURL:(NSURL *)URL ofType:(GBRBookType)type progress:(NSProgress *__autoreleasing *)progress cancellationCallback:(void (^)(NSData *))cancellationCallback;

@end
