//
// Created by Dmitry Zakharov on 4/24/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRTestUtilities.h"


@implementation GBRTestUtilities

- (instancetype)init {
    return (self = [super init]);
}

+ (instancetype)utilities {
    return [[self alloc] init];
}

- (id)jsonObjectFromFixtureWithName:(NSString *)fixtureName {
    NSURL *fixtureURL = [[NSBundle bundleForClass:[self class]] URLForResource:fixtureName withExtension:@"json"];

    __autoreleasing NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:fixtureURL] options:0 error:&error];
    NSAssert(jsonObject, @"JSON Object must be parsed correctly");
    NSAssert(!error, @"Error occured parsing fixture: %@", [error localizedDescription]);

    return jsonObject;
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
}

@end
