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


@implementation GBRAssembly

- (id<GBRAuthorization>)authorizer {
    return (id<GBRAuthorization>) [TyphoonDefinition withClass:[GBRGoogleAuthorization class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithDelegate:);
        [initializer injectWithObjectInstance:[UIApplication sharedApplication].delegate];
    } properties:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)myUploadedBooksNetworkFetcher {
    return [TyphoonDefinition withClass:[GBRMyUploadedBooksNetworkFetcher class] properties:^(TyphoonDefinition *definition) {
        definition.parent = [self baseNetworkFetcher];
    }];
}

- (id)myUploadedBooksStorage {
    return [TyphoonDefinition withClass:[GBRMyUploadedBooksStorage class] properties:^(TyphoonDefinition *definition) {
        definition.parent = [self baseStorage];
    }];
}

- (id)baseNetworkFetcher {
    return [TyphoonDefinition withClass:[GBRBaseNetworkFetcher class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithToken:);
        [initializer injectWithValueAsText:[self token]];
    } properties:^(TyphoonDefinition *definition) {
        definition.abstract = YES;
    }];
}

- (id)baseStorage {
    return [TyphoonDefinition withClass:[GBRStorage class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithUserName:);
        [initializer injectWithValueAsText:[self userName]];
    } properties:^(TyphoonDefinition *definition) {
        definition.abstract = YES;
    }];
}

- (NSString *)token {
    return [[GBRObjectFactory authorizer] token];
}

- (NSString *)userName {
    return [[GBRObjectFactory authorizer] userName];
}

@end
