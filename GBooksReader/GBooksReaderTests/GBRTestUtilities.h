//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


@interface GBRTestUtilities : NSObject

@property (nonatomic, readonly, copy) NSString *token;

+ (instancetype)utilities;

- (id)jsonObjectFromFixtureWithName:(NSString *)fixtureName;

@end
