//
//  GBRMyUploadedBooksStorageSpec.m
//  GBooksReader
//
//  Created by Dmitry Zakharov on 4/27/14.
//  Copyright 2014 comfly. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "GBRMyUploadedBooksStorage.h"
#import "GBRMyUploadedBooksStorage+Tests.h"
#import "GBRStorage+Protected.h"
#import "GBRBook.h"


SPEC_BEGIN(GBRMyUploadedBooksStorageSpec)


describe(@"GBRMyUploadedBooksStorage", ^{

    let(kUserName, ^{ return @"sample-user-name"; });
    let(fileManager, ^{ return [[NSFileManager alloc] init]; });

    beforeEach(^{
        NSURL *storageURL = [GBRMyUploadedBooksStorage cachesDirectoryURLForUserName:kUserName];
        [fileManager removeItemAtURL:storageURL error:NULL];
    });

    context(@"saving books", ^{
        beforeEach(^{
            NSURL *storageURL = [GBRMyUploadedBooksStorage cachesDirectoryURLForUserName:kUserName];
            [fileManager removeItemAtURL:storageURL error:NULL];
        });

        it(@"should create Storage directory if not created on instantiation", ^{
            NSString *storagePath = [[GBRMyUploadedBooksStorage cachesDirectoryURLForUserName:kUserName] path];
            [[storagePath shouldNot] beEmpty];

            [[theValue([fileManager fileExistsAtPath:storagePath isDirectory:NULL]) should] beNo];

            [[[[GBRMyUploadedBooksStorage alloc] initWithUserName:kUserName] should] beNonNil];

            BOOL isDirectory;
            [[theValue([fileManager fileExistsAtPath:storagePath isDirectory:&isDirectory] && isDirectory) should] beYes];
        });

        it(@"should store books into the Storage", ^{
            GBRMyUploadedBooksStorage *storage = [[GBRMyUploadedBooksStorage alloc] initWithUserName:kUserName];

            NSData *JSONData = [NSData dataWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"book-sample" withExtension:@"json"]];
            __autoreleasing NSError *error;
            NSArray *JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
            [[JSONObject should] beNonNil];
            [[JSONObject should] haveCountOf:2];
            [[error should] beNil];

            NSArray *books = [JSONObject bk_map:^(NSDictionary *bookDictionary) {
                __autoreleasing NSError *parsingError;
                GBRBook *result = [MTLJSONAdapter modelOfClass:[GBRBook class] fromJSONDictionary:bookDictionary error:&parsingError];
                [[parsingError should] beNil];
                [[result should] beNonNil];
                return result;
            }];

            [[books should] haveCountOf:2];

            [[[[books firstObject] id] should] equal:@"The ID 1"];
            [[[[books lastObject] id] should] equal:@"skoBAQAAAEAJ"];

            NSString *filePath = [storage booksStoragePath];
            [[theValue([fileManager fileExistsAtPath:filePath isDirectory:NULL]) should] beNo];

            [storage storeBooks:[storage booksByIDsDictionaryFromBooks:books]];

            BOOL isDirectory;
            [[theValue([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beNo];
        });
    });

    context(@"having books in the Storage", ^{
        let(storage, ^{ return [[GBRMyUploadedBooksStorage alloc] initWithUserName:kUserName]; });

        beforeEach(^{
            __autoreleasing NSError *storingError;
            BOOL copyResult = [fileManager copyItemAtURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"books-list" withExtension:@"bin"]
                                                   toURL:[NSURL fileURLWithPath:[storage booksStoragePath]] error:&storingError];
            [[theValue(copyResult) should] beYes];
            [[storingError should] beNil];
        });

        it(@"should load books from the Storage", ^{
            NSDictionary *books = [storage loadAllBooks];
            [[books should] beNonNil];
            [[books should] haveCountOf:2];

            [[books[@"The ID 1"] should] beKindOfClass:[GBRBook class]];
            [[books[@"skoBAQAAAEAJ"] should] beKindOfClass:[GBRBook class]];
        });
    });
});

SPEC_END
