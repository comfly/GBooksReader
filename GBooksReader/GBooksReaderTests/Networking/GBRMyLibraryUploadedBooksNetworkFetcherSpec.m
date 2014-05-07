//
//  GBRMyLibraryUploadedBooksNetworkFetcherSpec.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/26/14.
//  Copyright 2014 comfly. All rights reserved.
//

#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import <Typhoon/TyphoonPatcher.h>
#import "GBRMyUploadedBooksNetworkFetcher.h"
#import "GBRTestUtilities.h"
#import "GBRNetworkPaths.h"
#import "GBRBook.h"
#import "GBRDateFormatters.h"
#import "GBRThumbnailURLs.h"
#import "GBRReadingPosition.h"
#import "GBRAssembly.h"
#import "GBRGoogleAuthorization.h"
#import "GBRTestAssembly.h"


SPEC_BEGIN(GBRMyLibraryUploadedBooksNetworkFetcherSpec)

describe(@"GBRMyUploadedBooksNetworkFetcher", ^{

    NSString *const kToken = @"$@MPL3_T0KeN";

    let(utilities, ^{ return [GBRTestUtilities utilities]; });

    let(kRequestPath, ^{ return [GBRNetworkPaths pathToMyUploadedBooks]; });

    let(kResponseFixture, ^{ return @"uploaded-books-response"; });

    __block GBRMyUploadedBooksNetworkFetcher *fetcher;
    beforeAll(^{
        GBRAssembly *assembly = [GBRTestAssembly assembly];
        TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:assembly];

        TyphoonPatcher *patcher = [[TyphoonPatcher alloc] init];
        [patcher patchDefinition:[assembly authorizer] withObject:^{
            GBRGoogleAuthorization *authorization = [[GBRGoogleAuthorization alloc] init];
            [authorization stub:@selector(token) andReturn:kToken];
            return authorization;
        }];
        [factory attachPostProcessor:patcher];

        fetcher = [factory componentForKey:SELECTOR_NAME(myUploadedBooksNetworkFetcher)];
    });

    it(@"should load Uploaded Books", ^{
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

        Promise *promise = [fetcher loadMyUploadedBooks];

        __block BOOL done = NO;

        promise.then(^(NSArray *books) {
            [[books should] beNonNil];
            [[books should] haveCountOf:2];

            GBRBook *book = [books firstObject];
            [[book.id should] equal:@"The ID 1"];
            [[book.title should] equal:@"The Title 1"];
            [[book.subtitle should] equal:@"The Subtitle 1"];
            [[book.synopsis should] equal:@"The Description 1"];
            [[book.authors should] beNil];
            [[book.publisher should] equal:@"The Publisher 1"];
            [[book.publishedDate should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2014-03-06T22:26:05.486Z"]];
            [[theValue(book.printType) should] equal:theValue(GBRPrintTypeBook)];
            [[theValue(book.pageCount) should] equal:theValue(200)];
            [[[book should] have:2] categories];
            [[book.categories[0] should] equal:@"fiction"];
            [[book.categories[1] should] equal:@"books"];
            [[[book.imageLinks.smallThumbnail absoluteString] should] equal:@"http://test.link.ru/smallThumbnail"];
            [[[book.imageLinks.thumbnail absoluteString] should] equal:@"http://test.link.ru/thumbnail"];
            [[[book.imageLinks.small absoluteString] should] equal:@"http://test.link.ru/small"];
            [[[book.imageLinks.medium absoluteString] should] equal:@"http://test.link.ru/medium"];
            [[[book.imageLinks.large absoluteString] should] equal:@"http://test.link.ru/large"];
            [[[book.imageLinks.extraLarge absoluteString] should] equal:@"http://test.link.ru/extraLarge"];
            [[book.mainCategory should] equal:@"fiction"];
            [[theValue(book.rating) should] equal:theValue(GBRRatingFive)];
            [[[book.PDFDownloadLink absoluteString] should] equal:@"http://book.google.com/pdf"];
            [[[book.PDFACSTokenLink absoluteString] should] equal:@"http://book.google.com/acstokenlink"];
            [[book.EPUBDownloadLink should] beNil];
            [[book.EPUBACSTokenLink should] beNil];
            [[book.readingPosition.EPUBCFIPosition should] equal:@"epubCfiPosition 1"];
            [[book.readingPosition.imagePosition should] equal:@"gbImagePosition 1"];
            [[book.readingPosition.textPosition should] equal:@"gbTextPosition 1"];
            [[book.readingPosition.PDFPosition should] equal:@"pdfPosition 1"];
            [[book.readingPosition.updatedAt should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2014-03-10T22:59:15.741Z"]];
            [[book.updatedAt should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2014-04-13T22:59:15.741Z"]];
            [[theValue(book.status) should] equal:theValue(GBRProcessingStateSuccess)];

            book = [books lastObject];
            [[book.id should] equal:@"skoBAQAAAEAJ"];
            [[book.title should] equal:@"Learning iOS Development: A Hands-on Guide to the Fundamentals of iOS Programming (Jason Arnold's Library)"];
            [[book.subtitle should] beNil];
            [[book.synopsis should] beNil];
            [[[book should] have:1] authors];
            [[[book.authors firstObject] should] equal:@"Maurice Sharp"];
            [[book.publisher should] equal:@"Addison-Wesley Professional"];
            [[book.publishedDate should] beNil];
            [[theValue(book.printType) should] equal:theValue(GBRPrintTypeMagazine)];
            [[theValue(book.pageCount) should] equal:theValue(0)];
            [[book.categories should] beNil];
            [[[book.imageLinks.smallThumbnail absoluteString] should] equal:@"http://bks0.books.google.ru/books?id=skoBAQAAAEAJ&printsec=frontcover&img=1&zoom=5&uvs=3&source=gbs_api"];
            [[[book.imageLinks.thumbnail absoluteString] should] equal:@"http://bks0.books.google.ru/books?id=skoBAQAAAEAJ&printsec=frontcover&img=1&zoom=1&uvs=3&source=gbs_api"];
            [[book.imageLinks.small should] beNil];
            [[book.imageLinks.medium should] beNil];
            [[book.imageLinks.large should] beNil];
            [[book.imageLinks.extraLarge should] beNil];
            [[book.mainCategory should] beNil];
            [[theValue(book.rating) should] equal:theValue(GBRRatingNone)];
            [[[book.EPUBDownloadLink absoluteString] should] equal:@"http://books.google.com/epub"];
            [[[book.EPUBACSTokenLink absoluteString] should] equal:@"http://books.google.com/epubAcsLink"];
            [[book.PDFDownloadLink should] beNil];
            [[book.PDFACSTokenLink should] beNil];
            [[book.readingPosition should] beNil];
            [[book.updatedAt should] equal:[[GBRDateFormatters timestampFormatter] dateFromString:@"2014-03-06T22:26:05.486Z"]];
            [[theValue(book.status) should] equal:theValue(GBRProcessingStateSuccess)];

            done = YES;
        });

        [[expectFutureValue(theValue(done)) shouldEventually] beYes];
    });

    it(@"should support cancelling of loading books", ^{
        [OHHTTPStubs stubRequestsPassingTest:^(id _) {
            return YES;
        } withStubResponse:^(NSURLRequest *request) {
            id jsonObject = [utilities jsonObjectFromFixtureWithName:kResponseFixture];
            return [[OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:200 headers:nil] responseTime:3];
        }];

        __block BOOL done = NO;

        Promise *promise = [fetcher loadMyUploadedBooks];
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
