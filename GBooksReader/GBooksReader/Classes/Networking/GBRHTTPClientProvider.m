//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRHTTPClientProvider.h"
#import "GBRHTTPClient.h"


@interface GBRHTTPClient (Internal)

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

    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] initInternal];
    });

    return instance;
}

- (GBRHTTPClient *)objectForKeyedSubscript:(NSString *)token {
    GBRHTTPClient *result = [self.clients objectForKey:token];
    if (!result) {
        result = [[GBRHTTPClient alloc] initWithToken:token];
        [self.clients setObject:result forKey:token];
    }

    return result;
}


@end
