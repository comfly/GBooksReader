//
//  GBRGoogleOAuthRequestBuilder.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/19/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRGoogleOAuthRequestBuilder.h"


@interface GBRGoogleOAuthRequestBuilder ()

@property (nonatomic, readonly, copy) NSString *clientID;
@property (nonatomic, readonly, copy) NSString *clientSecret;
@property (nonatomic, readonly, copy) NSString *redirectURI;

@end

@implementation GBRGoogleOAuthRequestBuilder

- (instancetype)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURI:(NSString *)redirectURI {
    NSParameterAssert([clientID length] > 0);
    NSParameterAssert([clientSecret length] > 0);
    NSParameterAssert([redirectURI length] > 0);

    self = [super init];
    if (self) {
        _clientID = [clientID copy];
        _clientSecret = [clientSecret copy];
        _redirectURI = [redirectURI copy];
    }

    return self;
}

- (NSURLRequest *)initialRequest {
    NSURLComponents *components = [NSURLComponents componentsWithURL:[self initialURL] resolvingAgainstBaseURL:YES];
    components.query = [self buildQueryWithDictionary:[self commonQueryParametersWithAdditionalItems:@{
            @"client_id"     : self.clientID,
            @"redirect_uri"  : self.redirectURI,
            @"response_type" : @"code",
    }]];
    return [NSURLRequest requestWithURL:[components URL]];
}

- (NSURLRequest *)tokenAcquizitionRequestWithCode:(NSString *)code {
    NSMutableURLRequest *result = [NSMutableURLRequest requestWithURL:[self tokenRequestURL]];
    [result setHTTPMethod:@"POST"];
    [result setHTTPBody:[[self buildQueryWithDictionary:[self commonQueryParametersWithAdditionalItems:@{
            @"code"          : code,
            @"client_secret" : self.clientSecret,
            @"grant_type"    : @"authorization_code"
    }]] dataUsingEncoding:NSUTF8StringEncoding]];

    return [result copy];
}

- (NSString *)buildQueryWithDictionary:(NSDictionary *)dictionary {
    NSMutableArray *parts = [NSMutableArray arrayWithCapacity:[dictionary count]];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [parts addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];
    return [parts componentsJoinedByString:@"&"];
}

- (NSDictionary *)commonQueryParametersWithAdditionalItems:(NSDictionary *)additionalItems {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:@{
            @"client_id"    : self.clientID,
            @"redirect_uri" : self.redirectURI,
    }];
    [result addEntriesFromDictionary:additionalItems];
    return [result copy];
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/"];
}

- (NSURL *)initialURL {
    return [NSURL URLWithString:@"auth" relativeToURL:[self baseURL]];
}

- (NSURL *)tokenRequestURL {
    return [NSURL URLWithString:@"token" relativeToURL:[self baseURL]];
}

@end