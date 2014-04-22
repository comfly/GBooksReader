//
// Created by Dmitry Zakharov on 4/22/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import "GBRHTTPClient.h"
#import "GBRConfiguration.h"


@interface GBRHTTPClient ()

@property (nonatomic, readonly) AFHTTPSessionManager *manager;
@property (nonatomic, readonly, copy) NSString *token;

@end

@implementation GBRHTTPClient

- (instancetype)initWithToken:(NSString *)token {
    NSParameterAssert(token);

    self = [super init];
    if (self) {
        _token = [token copy];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self baseURL] sessionConfiguration:[self sessionConfiguration]];
        _manager.requestSerializer = [self requestSerializerWithToken:token];
        _manager.responseSerializer = [self responseSerializer];
    }

    return self;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    return [AFJSONResponseSerializer serializer];
}

- (AFHTTPRequestSerializer *)requestSerializerWithToken:(NSString *)token {
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [serializer setValue:[self tokenHeaderValueForToken:token] forHTTPHeaderField:@"Authorization"];

    return serializer;
}

- (NSURL *)baseURL {
    return [GBRConfiguration configuration].baseURL;
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (NSString *)tokenHeaderValueForToken:(NSString *)token {
    return [NSString stringWithFormat:@"Bearer %@", token];
}

@end
