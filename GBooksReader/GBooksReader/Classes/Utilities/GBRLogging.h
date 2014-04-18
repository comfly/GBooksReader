//
//  GBRLogging.h
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/19/14.
//  Copyright (c) 2014 comfly. All rights reserved.
//

#ifndef GBooksReader_GBRLogging____FILEEXTENSION___
#define GBooksReader_GBRLogging____FILEEXTENSION___

#import <CocoaLumberjack/DDTTYLogger.h>

#if defined DEBUG

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#else

static const int ddLogLevel = LOG_LEVEL_WARN;

#endif

static inline void GBRSetupLogger(void) {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

#endif
