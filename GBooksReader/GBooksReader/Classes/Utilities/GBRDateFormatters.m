//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRDateFormatters.h"


@implementation GBRDateFormatters

+ (NSDateFormatter *)timestampFormatter {
    static NSDateFormatter *formatter = nil;

    NSString *const kRFC3339Format = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

    ONCE(^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:kRFC3339Format];
    });

    return formatter;
}

@end
