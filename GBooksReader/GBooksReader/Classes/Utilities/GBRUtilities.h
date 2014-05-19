//
//  GBRUtilities.h
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
//



#ifndef __GBRUtilities_H_
#define __GBRUtilities_H_

#define SELECTOR_NAME(_selector)   \
    NSStringFromSelector(@selector(_selector))

#define DESIGNATED_INITIALIZER  \
    __attribute__((objc_designated_initializer))

#define ONCE(_block)    \
    do {    \
        static dispatch_once_t dispatchOnceToken;   \
        dispatch_once(&dispatchOnceToken, _block);  \
    } while (NO)

#define FORMAT(_template, ...)  \
    [NSString stringWithFormat:_template, ##__VA_ARGS__]

#define IS_TEST_RUN \
    [[GBRConfiguration configuration] isTestRun]

#define GBR_CONST __attribute__((const))

#define SAFE_BLOCK_CALL(_block, ...)	\
	if (_block) { _block(__VA_ARGS__); }


#endif //__GBRUtilities_H_
