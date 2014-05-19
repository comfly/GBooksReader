//
// Created by Dmitry Zakharov on 5/10/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

#import <Maris/REMHTTPSessionManager.h>
#import "GBRBaseDataFetcher.h"
#import "GBRBaseNetworkFetcher+Protected.h"


@interface GBRBaseDataFetcher ()

@property (nonatomic) REMHTTPSessionManager *manager;

@end

@implementation GBRBaseDataFetcher

- (REMCompoundResponseSerializer *)responseSerializer {
    return [REMCompoundResponseSerializer serializer];
}

- (NSURL *)baseURL GBR_CONST {
    return [GBRConfiguration configuration].baseURL;
}

- (void (^)(NSURLSessionDataTask *, NSError *))defaultNetworkErrorProcessingBlockWithRejecter:(PromiseResolver)rejecter {
    @weakify(self);
    return ^(NSURLSessionDataTask *_, NSError *error) {
        @strongify(self);
        if ([[error domain] isEqualToString:NSURLErrorDomain]) {
            [self processStandardNetworkError:error];
        }
        if ([self mustLogNetworkError:error]) {
            DDLogCError(@"Network error: %@", error);
        }
        rejecter(error);
    };
}

@end
