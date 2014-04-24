//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


typedef NS_ENUM(NSInteger, GBRErrorCodes) {
    GBRErrorBase = 1001,
    GBRResponseParsingError
};

extern NSString *const GBRErrorDomain;

@interface NSError (GBRExtra)

+ (NSError *)applicationErrorWithCode:(GBRErrorCodes)code userInfo:(NSDictionary *)userInfo;

+ (NSError *)applicationErrorWithCode:(GBRErrorCodes)code message:(NSString *)message;

- (BOOL)isOfflineError;

- (BOOL)isUserCancelled;

@end
