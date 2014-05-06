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
#import "AFJSONRequestSerializer+GBRExtra.h"


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
        [definition useInitializer:@selector(init)];
        [definition injectProperty:@selector(manager) with:[self networkManager]];
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

- (id)networkManager {
    return [TyphoonDefinition withClass:[REMHTTPSessionManager class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
        [definition useInitializer:@selector(initWithBaseURL:sessionConfiguration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameter:@"baseURL" with:[GBRConfiguration configuration].baseURL];
            [initializer injectParameter:@"sessionConfiguration" with:[self sessionConfiguration]];
        }];
        [definition injectProperty:@selector(requestSerializer) with:[self requestSerializer]];
        [definition injectProperty:@selector(responseSerializer) with:[self responseSerializer]];
    }];
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (TyphoonDefinition *)requestSerializer {
    return [TyphoonDefinition withClass:[AFJSONRequestSerializer class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(serializerWithWritingOptions:authorizationToken:) parameters:^(TyphoonMethod *method) {
            [method injectParameter:@"writingOptions" with:@(NSJSONWritingPrettyPrinted)];
            [method injectParameter:@"authorizationToken" with:[[self authorizer] property:@selector(token)]];
        }];
    }];
}

- (TyphoonDefinition *)responseSerializer {
    return [TyphoonDefinition withClass:[REMCompoundResponseSerializer class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(serializer)];
    }];
}

@end
