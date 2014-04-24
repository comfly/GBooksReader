//
//  GBRMyLibraryNetworkFetcherSpec.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/24/14.
//  Copyright 2014 comfly. All rights reserved.
//

#import "GBRMyLibraryNetworkFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"
#import "GBRTestUtilities.h"
#import "GBRBookshelf.h"
#import "GBRConfiguration.h"
#import "OHHTTPStubsResponse+JSON.h"
#import "GBRDateFormatters.h"


SPEC_BEGIN(GBRMyLibraryNetworkFetcherSpec)

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

            it(@"should load My Bookshelves", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    NSURL *kRequestURL = [[NSURL URLWithString:@"mylibrary/bookshelves" relativeToURL:[GBRConfiguration configuration].baseURL] absoluteURL];
                    BOOL URLsMatch = [[request URL] isEqual:kRequestURL];
                    BOOL bodyMatch = [request HTTPBody] == nil;
                    BOOL headersMatch = [[request valueForHTTPHeaderField:@"Authorization"] isEqualToString:FORMAT(@"Bearer %@", kToken)];

                    [[theValue(URLsMatch) should] beYes];
                    [[theValue(bodyMatch) should] beYes];
                    [[theValue(headersMatch) should] beYes];

                    return URLsMatch && bodyMatch && headersMatch;
                }                   withStubResponse:^(NSURLRequest *request) {
                    id jsonObject = [utilities jsonObjectFromFixtureWithName:@"my-bookshelves-response"];
                    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:200 headers:nil];
                }];


                Promise *promise = [fetcher loadAllBookshelves];

                __block BOOL done = NO;

                promise.then(^(NSArray<GBRBookshelf> *bookshelves) {
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
        });

        SPEC_END
