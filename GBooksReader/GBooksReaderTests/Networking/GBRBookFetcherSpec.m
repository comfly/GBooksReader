//
//  GBRBookFetcherSpec.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 5/20/14.
//  Copyright 2014 comfly. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "GBRBookFetcher.h"
#import "GBRBookFetcher+TestExtension.h"


SPEC_BEGIN(GBRBookFetcherSpec)

describe(@"GBRBookFetcher", ^{
    context(@"Basic downloading", ^{
        static NSString *const kBookID = @"Sample_book_id";
        static const GBRBookType kBookType = GBRBookTypePDF;
        static NSString *const kBookURLAsString = @"http://apple.com";
        static NSString *const kToken = @"SAMPLE_TOKEN";

        pending(@"should download book with Book ID, type, URL", ^{
            GBRBookFetcher *fetcher = [[GBRBookFetcher alloc] initWithBookID:kBookID type:kBookType URL:[NSURL URLWithString:kBookURLAsString] token:kToken];

            [OHHTTPStubs setEnabled:YES forSessionConfiguration:[fetcher sessionConfiguration]];
            [OHHTTPStubs stubRequestsPassingTest:^(NSURLRequest *request) {
                BOOL isTestURL = [[request URL] isEqual:[NSURL URLWithString:kBookURLAsString]];
                [[theValue(isTestURL) should] beYes];
                return isTestURL;
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                NSString *filePath = [[[NSBundle bundleForClass:[self class]] URLForResource:@"SampleBook" withExtension:@"pdf"] path];
                return [OHHTTPStubsResponse responseWithFileAtPath:filePath statusCode:200 headers:nil];
            }];

            __block BOOL done = NO;

            NSProgress *progress;
            [[(NSObject<GBRCancellable> *) [fetcher loadBookWithProgress:&progress completionBlock:^(NSURL *fileLocation, NSError *error) {
                [[error should] beNil];
                [[fileLocation should] equal:[GBRBookFetcher buildDestinationURLForBookWithID:kBookID type:kBookType]];

                BOOL directory;
                [[theValue([[NSFileManager defaultManager] fileExistsAtPath:[fileLocation path] isDirectory:&directory]) should] beYes];
                [[theValue(directory) should] beNo];

                done = YES;
            }] should] beNonNil];

            [[expectFutureValue(theValue(done)) shouldEventuallyBeforeTimingOutAfter(10)] beYes];
        });
    });
});

SPEC_END
