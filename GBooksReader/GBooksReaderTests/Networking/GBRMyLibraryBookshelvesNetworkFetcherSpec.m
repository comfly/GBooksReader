//
//  GBRMyLibraryBookshelvesNetworkFetcherSpec.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/24/14.
//  Copyright 2014 comfly. All rights reserved.
//

#import "GBRMyLibraryNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRTestUtilities.h"
#import "GBRBookshelf.h"
#import "OHHTTPStubsResponse+JSON.h"
#import "GBRDateFormatters.h"
#import "GBRNetworkPaths.h"


SPEC_BEGIN(GBRMyLibraryBookshelvesNetworkFetcherSpec)

describe(@"GBRMyLibraryNetworkFetcher", ^{

    let(kToken, ^{
        return @"$@MPL3_T0KeN";
    });

    let(fetcher, ^{
        return [[GBRMyLibraryNetworkFetcher alloc] initWithToken:kToken];
    });

    let(utilities, ^{
        return [GBRTestUtilities utilities];
    });

    let(kRequestPath, ^{
        return [GBRNetworkPaths pathToMyLibraryBookshelves];
    });

    let(kResponseFixture, ^{
        return @"my-bookshelves-response";
    });

    it(@"should load My Bookshelves", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            NSURL *kRequestURL = [[NSURL URLWithString:kRequestPath relativeToURL:[GBRConfiguration configuration].baseURL] absoluteURL];
            [[[[request URL] absoluteURL] should] equal:kRequestURL];
            [[[request HTTPBody] should] beNil];
            [[[request valueForHTTPHeaderField:@"Authorization"] should] equal:FORMAT(@"Bearer %@", kToken)];

            return YES;
        } withStubResponse:^(NSURLRequest *request) {
            id jsonObject = [utilities jsonObjectFromFixtureWithName:kResponseFixture];
            return [OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:200 headers:nil];
        }];

        Promise *promise = [fetcher loadAllBookshelves];

        __block BOOL done = NO;

        promise.then(^(NSArray *bookshelves) {
            [[bookshelves should] beNonNil];
            [[bookshelves should] haveCountOf:10];

            GBRBookshelf *bookshelf = [bookshelves firstObject];
            [[bookshelf.title should] equal:@"My Google eBooks"];
            [[theValue(bookshelf.id) should] equal:theValue(7)];
            [[theValue(bookshelf.volumeCount) should] equal:theValue(1)];

            [[bookshelf.updatedAt should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2011-06-01T13:34:16.368Z"]];
            [[bookshelf.createdAt should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2011-06-01T13:34:16.368Z"]];
            [[bookshelf.volumesLastUpdated should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2014-04-23T22:35:04.000Z"]];

            done = YES;
        });

        [[expectFutureValue(theValue(done)) shouldEventually] beYes];
    });

    it(@"should support cancelling of loading My Bookshelves", ^{
        [OHHTTPStubs stubRequestsPassingTest:^(id _) {
            return YES;
        } withStubResponse:^(NSURLRequest *request) {
            id jsonObject = [utilities jsonObjectFromFixtureWithName:kResponseFixture];
            return [[OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:200 headers:nil] responseTime:3];
        }];

        __block BOOL done = NO;

        Promise *promise = [fetcher loadAllBookshelves];
        promise.catch(^(NSError *error) {
            [[theValue([error isUserCancelled]) should] beYes];
            done = YES;
        });

        [NSThread sleepForTimeInterval:0.3];

        [fetcher cancelTaskForPromise:promise];
        [[expectFutureValue(theValue(done)) shouldEventually] beYes];
    });
});

SPEC_END
