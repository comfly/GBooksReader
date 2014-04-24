//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "NSError+GBRExtra.h"

NSString *const GBRErrorDomain = @"com.comfly.GBooksReader.ErrorDomain";


@implementation NSError (GBRExtra)

+ (NSError *)applicationErrorWithCode:(GBRErrorCodes)code userInfo:(NSDictionary *)userInfo {
    return [self errorWithDomain:GBRErrorDomain code:code userInfo:userInfo];
}

+ (NSError *)applicationErrorWithCode:(GBRErrorCodes)code message:(NSString *)message {
    return [self applicationErrorWithCode:code userInfo:message ? @{ NSLocalizedDescriptionKey : message } : nil];
}

- (BOOL)isOfflineError {
    return [[self domain] isEqualToString:NSURLErrorDomain] && [self code] == NSURLErrorNotConnectedToInternet;
}

- (BOOL)isUserCancelled {
    return [[self domain] isEqualToString:NSURLErrorDomain] && [self code] == NSURLErrorCancelled;
}

@end
