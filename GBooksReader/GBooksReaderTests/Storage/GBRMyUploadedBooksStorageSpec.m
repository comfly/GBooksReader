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
        id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
        [[JSONObject should] beNonNil];
        [[error should] beNil];

        GBRBook *book = [MTLJSONAdapter modelOfClass:[GBRBook class] fromJSONDictionary:JSONObject error:NULL];
        [[book.id should] equal:@"The ID 1"];

        NSString *filePath = [storage booksStoragePath];
        [[theValue([fileManager fileExistsAtPath:filePath isDirectory:NULL]) should] beNo];

        [storage storeBooks:[storage booksByIDsDictionaryFromBooks:@[ book ]]];

        BOOL isDirectory;
        [[theValue([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) should] beYes];
        [[theValue(isDirectory) should] beNo];
    });
});

SPEC_END
