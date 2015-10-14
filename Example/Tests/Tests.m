//
//  HNClient-iOSTests.m
//  HNClient-iOSTests
//
//  Created by yuchan on 03/04/2015.
//  Copyright (c) 2014 yuchan. All rights reserved.
//

#import "HNClient.h"

SpecBegin(InitialSpecs)

describe(@"these will pass", ^{
    it(@"should do some stuff asynchronously", ^{
        waitUntil(^(DoneCallback done) {
            // Async example blocks need to invoke done() callback.
            HNClient *cl = [[HNClient alloc] init];
            [cl loadTopStories:^(HNItem *item, NSError *error) {
                if (item) {
                    expect(item.title).notTo.beNil();
                    expect(item.type).notTo.beNil();
                    if([item.type isEqual:@"poll"]) {
                        expect(item.descendants).notTo.beNil();
                    }
                }
            } completion:^(BOOL isCancelled, NSArray *items) {
                expect([items count]).to.beGreaterThanOrEqualTo(0);
                HNItem *par = [items objectAtIndex:0];

                [cl loadChild:par OnChildLoaded:^(HNItem *item, HNItem *parent) {
                    if (!item.deleted && !item.dead) {
                        expect(item.username).notTo.beNil();
                    }
                    
                    if (item.itemType == HNItemTypeAsk) {
                        NSLog(@"%@", @"ask");
                    }
                } completion:^(BOOL isCancelled, NSArray *childs) {
                    expect([childs count]).to.beGreaterThanOrEqualTo(0);
                    done();
                }];
            }];
        });
    });
});

SpecEnd
