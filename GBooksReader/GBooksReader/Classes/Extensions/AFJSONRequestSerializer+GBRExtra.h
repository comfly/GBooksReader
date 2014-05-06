//
// Created by Dmitry Zakharov on 5/7/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;

@interface AFJSONRequestSerializer (GBRExtra)

+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions authorizationToken:(NSString *)token;

@end
