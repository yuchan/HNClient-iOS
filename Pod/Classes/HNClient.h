//
//  HNClient.h
//  HNPick
//
//  Created by Ohashi Yusuke on 1/28/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HNItem.h"
#import "HNClient-iOS-Swift.h"

static NSString* const firebase_endpoint = @"https://hacker-news.firebaseio.com/v0/";

@interface HNClient : NSObject
- (void)loadTopStories:(void (^)(HNItem* item, NSError* error))block;
- (void)loadTopStories:(void (^)(HNItem *, NSError *))block completion:(void (^)(BOOL isCancelled, NSArray *items))completion;
- (void)loadUser:(NSString *)userName complete:(void (^)(HNUser* user, NSError* error, NSInteger idx, NSInteger count))block;
- (void)loadChild:(HNItem*)parent OnChildLoaded:(void (^)(HNItem* item, HNItem* parent))block;
- (void)loadChild:(HNItem*)parent OnChildLoaded:(void (^)(HNItem* item, HNItem* parent))block completion:(void (^)(BOOL isCancelled, NSArray *childs))completion;
@end
