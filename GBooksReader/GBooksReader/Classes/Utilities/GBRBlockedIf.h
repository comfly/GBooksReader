//
// Created by Dmitry Zakharov on 5/20/14.
// Copyright (c) 2014 comfly. All rights reserved.
//

@import Foundation;


@interface GBRBlockedIf : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (id)then:(id(^)(void))thenBlock;
- (id)then:(id(^)(void))thenBlock else:(id(^)(void))elseBlock;

@end

extern GBRBlockedIf *GBRIf(BOOL);

#define If GBRIf
#define Then then:^
#define Else else:^
#define Elsif(__predicate) else:^{ return GBRIf(__predicate); }]

@interface NSObject (GBRBlockedIf)
- (id)then:(id(^)(void))thenBlock;
- (id)then:(id(^)(void))thenBlock else:(id(^)(void))elseBlock;
@end
