//
//  GBRAssembly.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/23/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRAssembly.h"
#import "GBRBaseNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRAuthorization.h"
#import "GBRMyUploadedBooksNetworkFetcher.h"
#import "GBRGoogleAuthorization.h"
#import "GBRMyUploadedBooksStorage.h"
#import "TyphoonMethod+InstanceBuilder.h"


@implementation GBRAssembly

- (id)authorizer {
    return [TyphoonDefinition withClass:[GBRGoogleAuthorization class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
        [definition useInitializer:@selector(initWithDelegate:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[UIApplication sharedApplication].delegate];
        }];
    }];
}

- (id)myUploadedBooksNetworkFetcher {
    return [TyphoonDefinition withClass:[GBRMyUploadedBooksNetworkFetcher class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = [self baseNetworkFetcher];
    }];
}

- (id)myUploadedBooksStorage {
    return [TyphoonDefinition withClass:[GBRMyUploadedBooksStorage class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = [self baseStorage];
    }];
}

- (id)baseNetworkFetcher {
    return [TyphoonDefinition withClass:[GBRBaseNetworkFetcher class] configuration:^(TyphoonDefinition *definition) {
        definition.abstract = YES;
        [definition useInitializer:@selector(initWithToken:) parameters:^(TyphoonMethod *initializer) {
            NSString *token = [[self authorizer] property:@selector(token)];
            [initializer injectParameterWith:token];
        }];
    }];
}

- (id)baseStorage {
    return [TyphoonDefinition withClass:[GBRStorage class] configuration:^(TyphoonDefinition *definition) {
        definition.abstract = YES;
        [definition useInitializer:@selector(initWithUserName:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[[self authorizer] property:@selector(userName)]];
        }];
    }];
}

@end
