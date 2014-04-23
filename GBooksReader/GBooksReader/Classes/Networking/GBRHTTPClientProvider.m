//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRHTTPClientProvider.h"
#import "GBRBaseNetworkFetcher.h"


@interface GBRBaseNetworkFetcher (Internal)

- (instancetype)initWithToken:(NSString *)token;
- (NSString *)token;

@end


@interface GBRHTTPClientProvider ()

@property (nonatomic, readonly) NSCache *clients;

@end

@implementation GBRHTTPClientProvider

- (instancetype)initInternal {
    self = [super init];
    if (self) {
        _clients = [self cacheWithName:@"com.comfly.GBooksReader.HTTPClientsCache"];
    }

    return self;
}

- (NSCache *)cacheWithName:(NSString *)name {
    NSCache *result = [[NSCache alloc] init];
    [result setName:name];

    return result;
}

+ (instancetype)provider {
    static GBRHTTPClientProvider *instance;

    ONCE(^{
        instance = [[self alloc] initInternal];
    });

    return instance;
}

- (GBRBaseNetworkFetcher *)objectForKeyedSubscript:(NSString *)token {
    return self.clients[token] ?: (self.clients[token] = [[GBRBaseNetworkFetcher alloc] initWithToken:token]);
}


@end
