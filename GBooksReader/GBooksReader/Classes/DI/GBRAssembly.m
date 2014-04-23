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
#import "GBRMyLibraryNetworkFetcher.h"


@implementation GBRAssembly

- (id)myLibraryNetworkFetcher {
    return [TyphoonDefinition withClass:[GBRMyLibraryNetworkFetcher class] properties:^(TyphoonDefinition *definition) {
        definition.parent = [self baseNetworkFetcher];
    }];
}

- (id)baseNetworkFetcher {
    return [TyphoonDefinition withClass:[GBRBaseNetworkFetcher class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithToken:);
        [initializer injectWithValueAsText:[self token]];
    }                        properties:^(TyphoonDefinition *definition) {
        definition.abstract = YES;
    }];
}

- (NSString *)token {
    return nil;
}

@end