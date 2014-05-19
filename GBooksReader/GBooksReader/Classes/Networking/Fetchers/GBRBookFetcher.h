//
// Created by Dmitry Zakharov on 4/29/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;
#import "GBRBaseFileFetcher.h"

@protocol GBRCancellable;

@interface GBRBookFetcher : GBRBaseFileFetcher

- (instancetype)initWithUniqueIdentifier:(NSString *)identifier token:(NSString *)token URL:(NSURL *)URL NS_UNAVAILABLE;

- (instancetype)initWithBookID:(NSString *)bookID type:(GBRBookType)type URL:(NSURL *)URL token:(NSString *)token;
+ (void)completeBackgroundLoadingWithSessionIdentifier:(NSString *)sessionID backgroundDownloadCompletionHandler:(void (^)(void))backgroundDownloadCompletionHandler completionHandler:(void (^)(NSString *bookID, GBRBookType type, NSURL *fileURL))completionHandler;

- (id<GBRCancellable>)loadBookWithProgress:(NSProgress *__autoreleasing *)progress completionBlock:(void (^)(NSURL *fileLocation, NSError *error))completionBlock;

@end
