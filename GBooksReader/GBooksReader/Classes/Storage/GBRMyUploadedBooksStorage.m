//
//  GBRMyUploadedBooksStorage.m
//  GBooksReader
//
// Created by Dmitry Zakharov on 4/27/14.
// Copyright (c) 2014 comfly. All rights reserved.
//


#import "GBRMyUploadedBooksStorage.h"
#import "GBRStorage+Protected.h"
#import "GBRBook.h"


@interface GBRMyUploadedBooksStorage ()

@property (nonatomic, readonly) NSString *booksStoragePath;

@end


@implementation GBRMyUploadedBooksStorage

- (instancetype)initWithUserName:(NSString *)userName {
    self = [super initWithUserName:userName];
    if (self) {
        _booksStoragePath = [[[self networkCachesDirectoryURL] URLByAppendingPathComponent:@"books-list.bin" isDirectory:NO] path];
    }

    return self;
}

- (NSDictionary *)loadAllBooks {
    return [self booksByIDsDictionaryFromBooks:[self loadBooksArray]];
}

- (void)storeBooks:(NSDictionary *)books {
    NSMutableDictionary *existingBooks = [NSMutableDictionary dictionaryWithDictionary:[self loadAllBooks]];

    NSSet *IDsOfBooksToDelete = [[NSSet setWithArray:[existingBooks allKeys]] gbr_setMinusSet:[NSSet setWithArray:[books allKeys]]];

    [books bk_each:^(NSString *id, GBRBook *newBook) {
        GBRBook *oldBook = existingBooks[id];
        if (oldBook) {
            // Need merging.
            [oldBook mergeValuesForKeysFromModel:newBook];
        } else {
            // New book. Add as is.
            existingBooks[id] = newBook;
        }
    }];

    [existingBooks removeObjectsForKeys:[IDsOfBooksToDelete allObjects]];
    [self storeBooksArray:[existingBooks allValues]];
}

- (void)storeBooksArray:(NSArray *)books {
    [NSKeyedArchiver archiveRootObject:[books bk_map:^(GBRBook *book) {
        return [MTLJSONAdapter JSONDictionaryFromModel:book];
    }] toFile:self.booksStoragePath];
}

- (NSArray *)loadBooksArray {
    return [[NSKeyedUnarchiver unarchiveObjectWithFile:self.booksStoragePath] bk_map:^(NSDictionary *serializedBook) {
        __autoreleasing NSError *error;
        GBRBook *result = [MTLJSONAdapter modelOfClass:[GBRBook class] fromJSONDictionary:serializedBook error:&error];
        if (error) {
            DDLogCError(@"Error parsing GBRBook from Dictionary representation: %@", error);
        }

        return result;
    }];
}

- (NSDictionary *)booksByIDsDictionaryFromBooks:(NSArray *)books {
    return [books gbr_dictionaryWithKeyBlock:^(GBRBook *_) { return _.id; }];
}

@end