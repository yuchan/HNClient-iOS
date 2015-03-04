//
//  HNClient.m
//  HNPick
//
//  Created by Ohashi Yusuke on 1/28/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import "HNClient.h"
#import <Firebase/Firebase.h>

@interface HNClient()
@property (nonatomic) BOOL isDone;
@property (nonatomic) NSMutableArray *fbRefCache;
@property (nonatomic) NSMutableArray *storyCache;
@end

@implementation HNClient

- (id)init
{
    self = [super init];
    if (self) {
        _fbRefCache = [[NSMutableArray alloc] init];
        _storyCache = [[NSMutableArray alloc] init];
        return self;
    }
    
    return nil;
}

- (void)loadTopStories:(void (^)(HNItem* snapshot, NSError* error, NSInteger idx, NSInteger count))block
{
    for (Firebase *ref in self.fbRefCache) {
        [ref removeAllObservers];
    }
    [self.fbRefCache removeAllObjects];
    self.isDone = NO;
    Firebase* ref = [[Firebase alloc] initWithUrl:firebase_endpoint];
    ref = [ref childByAppendingPath:@"topstories"];
    [self.fbRefCache addObject:ref];
    [ref observeSingleEventOfType:FEventTypeValue
                withBlock:^(FDataSnapshot* snapshot) {
                    [self.storyCache removeAllObjects];
                    NSArray *topNewsIdArray = (NSArray *)snapshot.value;
                    for (NSNumber * num in topNewsIdArray) {
                        NSString *url = [NSString stringWithFormat:@"%@/item/%ld", firebase_endpoint, [num longValue]];
                        Firebase *r = [[Firebase alloc] initWithUrl:url];
                        [r observeSingleEventOfType:FEventTypeValue
                                          withBlock: ^(FDataSnapshot *snapshot) {
                                              [self.storyCache addObject:snapshot.value];
                                              if (block) {
                                                  if (snapshot.value && ![snapshot.value isEqual:[NSNull null]]){
                                                      HNItem *item = [[HNItem alloc] initWithItemDictionary:snapshot.value];
                                                      block(item, nil, self.storyCache.count, [topNewsIdArray count]);
                                                  }else{
                                                      block(nil, nil, self.storyCache.count, [topNewsIdArray count]);
                                                  }
                                              }
                                              if (self.storyCache.count == [topNewsIdArray count]) {
                                                  self.isDone = YES;
                                              }
                                          }
                         
                                    withCancelBlock: ^(NSError *error) {
                                        [self.storyCache addObject:error];
                                        if (block) {
                                            block(nil, error,self.storyCache.count, [topNewsIdArray count]);
                                        }
                                        if (self.storyCache.count == [topNewsIdArray count]) {
                                            self.isDone = YES;
                                        }
                                    }];
                    }
                }
          withCancelBlock:^(NSError* error) {
              self.isDone = YES;
              if (block) {
                  block(nil, error, 0, 0);
              }
          }];
}

- (void)loadUser:(NSString*)userName complete:(void (^)(HNUser *user, NSError* error, NSInteger idx, NSInteger count))block
{
    Firebase* fb = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/user/%@", firebase_endpoint, userName]];
    [fb observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot* snapshot) {
        if (snapshot && snapshot.value && ![snapshot.value isEqual:[NSNull null]]) {
            if (block) {
                HNUser *user = [[HNUser alloc] initWithItemDictionary:snapshot.value];
                block(user, nil, 0, 1);
            }
        }
    } withCancelBlock:^(NSError* error){
    }];
}

- (void)loadChild:(HNItem*)parent OnChildLoaded:(void (^)(HNItem* item, HNItem* parent))block onStart:(BOOL)onstart
{
    if (onstart) {
        for (Firebase *f in self.fbRefCache) {
            [f removeAllObservers];
        }
        [self.fbRefCache removeAllObjects];
    }
    
    NSArray* array = [parent childids];
    if (array && [array count] > 0) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            Firebase* fb = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/item/%ld", firebase_endpoint, [obj longValue]]];
            [self.fbRefCache addObject:fb];
            [fb observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot* snapshot) {
                if (snapshot && snapshot.value && ![snapshot.value isEqual:[NSNull null]]) {
                    HNItem *item = [[HNItem alloc] initWithItemDictionary:snapshot.value];
                    [item setParent:parent];
                    [item setDepth:parent.depth + 1];
                    [parent addChildItem:item];
                    if (block) {
                        block(item, parent);
                    }
                    [self loadChild:item OnChildLoaded:block onStart:NO];
                }
            } withCancelBlock:^(NSError* error){
            }];
        }];
    }
 
}

- (void)loadChild:(HNItem*)parent OnChildLoaded:(void (^)(HNItem* item, HNItem* parent))block
{
    [self loadChild:parent OnChildLoaded:block onStart:YES];
}
@end
