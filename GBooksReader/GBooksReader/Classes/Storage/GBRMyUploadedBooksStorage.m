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


@implementation GBRMyUploadedBooksStorage

- (NSDictionary *)loadAllBooks {
    return [self booksByIDsDictionaryFromBooks:[self loadBooksArray]];
}

- (void)storeBooks:(NSDictionary *)books {
    NSMutableDictionary *existingBooks = [NSMutableDictionary dictionaryWithDictionary:[self loadAllBooks]];

    NSSet *IDsOfBooksToDelete = [[NSSet setWithArray:[existingBooks allKeys]] gbr_setMinusSet:[NSSet setWithArray:[books allKeys]]];

    for (GBRBook *newBook in books) {
        GBRBook *oldBook = existingBooks[newBook.id];
        if (oldBook) {
            // Need merging.
            [oldBook mergeValuesForKeysFromModel:newBook];
        } else {
            // New book. Add as is.
            existingBooks[newBook.id] = newBook;
        }
    }

    [existingBooks removeObjectsForKeys:[IDsOfBooksToDelete allObjects]];
    [[existingBooks allValues] writeToURL:[self booksStorageURL] atomically:YES];
}

- (NSArray *)loadBooksArray {
    return [NSArray arrayWithContentsOfURL:[self booksStorageURL]];
}

- (NSDictionary *)booksByIDsDictionaryFromBooks:(NSArray *)books {
    return [books gbr_dictionaryWithKeyBlock:^(GBRBook *_) { return _.id; }];
}

- (NSURL *)booksStorageURL {
    return [[self networkCachesDirectoryURL] URLByAppendingPathComponent:@"books-list.plist" isDirectory:NO];
}

@end