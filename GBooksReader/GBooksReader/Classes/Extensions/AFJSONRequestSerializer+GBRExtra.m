//
// Created by Dmitry Zakharov on 5/7/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "AFJSONRequestSerializer+GBRExtra.h"


@implementation AFJSONRequestSerializer (GBRExtra)

+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions authorizationToken:(NSString *)token {
    AFJSONRequestSerializer *result = [self serializerWithWritingOptions:writingOptions];
    [result setValue:FORMAT(@"Bearer %@", token) forHTTPHeaderField:@"Authorization"];
    return result;
}

@end
