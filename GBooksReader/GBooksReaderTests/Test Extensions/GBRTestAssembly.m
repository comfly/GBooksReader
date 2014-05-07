//
// Created by Dmitry Zakharov on 5/7/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRTestAssembly.h"
#import "GBRGoogleAuthorization.h"


@implementation GBRTestAssembly

- (id)authorizer {
    return [TyphoonDefinition withClass:[GBRGoogleAuthorization class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end
