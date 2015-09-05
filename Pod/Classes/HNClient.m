//
//  HNClient.m
//  HNPick
//
//  Created by Ohashi Yusuke on 1/28/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import "HNClient.h"
#import "Firebase/Firebase.h"

@interface HNClient()
@property (nonatomic) NSMutableArray *fbRefCache;
@property (nonatomic) NSMutableArray *storyCache;
@property (nonatomic) NSMutableArray *stories;
@end

@implementation HNClient

- (id)init
{
    self = [super init];
    if (self) {
        _fbRefCache = [[NSMutableArray alloc] init];
        _storyCache = [[NSMutableArray alloc] init];
        _stories = [[NSMutableArray alloc] init];
        return self;
    }
    
    return nil;
}

- (void)loadTopStories:(void (^)(HNItem *, NSError *))block completion:(void (^)(BOOL,NSArray*))completion
{
    for (Firebase *ref in self.fbRefCache) {
        [ref removeAllObservers];
    }
    [self.fbRefCache removeAllObjects];
    Firebase* ref = [[Firebase alloc] initWithUrl:firebase_endpoint];
    ref = [ref childByAppendingPath:@"topstories"];
    [self.fbRefCache addObject:ref];
    [ref observeSingleEventOfType:FEventTypeValue
                        withBlock:^(FDataSnapshot* snapshot) {
                            // Clear Cache
                            [self.storyCache removeAllObjects];
                            [self.stories removeAllObjects];
                            NSArray *topNewsIdArray = (NSArray *)snapshot.value;
                            for (NSNumber * num in topNewsIdArray) {
                                NSString *url = [NSString stringWithFormat:@"%@/item/%ld", firebase_endpoint, [num longValue]];
                                Firebase *r = [[Firebase alloc] initWithUrl:url];
                                [r observeSingleEventOfType:FEventTypeValue
                                                  withBlock: ^(FDataSnapshot *snapshot) {
                                                      // Add Object for managing number of downloaded items.
                                                      [self.storyCache addObject:snapshot.value];
                                                      
                                                      // Sometimes you get [NSNull null] value, so we should be careful for that.
                                                      if (snapshot.value && ![snapshot.value isEqual:[NSNull null]]){
                                                          HNItem *item = [[HNItem alloc] initWithItemDictionary:snapshot.value];
                                                          // add a valid item here.
                                                          [self.stories addObject:item];
                                                          if (block) {
                                                              block(item, nil);
                                                          }
                                                      }else{
                                                          if (block) {
                                                              block(nil, nil);
                                                          }
                                                      }

                                                      if (self.storyCache.count == [topNewsIdArray count]) {
                                                          if (completion) {
                                                              completion(NO, self.stories);
                                                          }
                                                      }
                                                  }
                                 
                                            withCancelBlock: ^(NSError *error) {
                                                [self.storyCache addObject:error];
                                                if (block) {
                                                    block(nil, error);
                                                }
                                                if (self.storyCache.count == [topNewsIdArray count]) {
                                                    if (completion) {
                                                        completion(YES, self.stories);
                                                    }
                                                }
                                            }];
                            }
                        }
                  withCancelBlock:^(NSError* error) {
                      if (block) {
                          block(nil, error);
                      }
                      
                      if (completion) {
                          completion(YES, self.stories);
                      }
                  }];
}

- (void)loadTopStories:(void (^)(HNItem* snapshot, NSError* error))block
{
    [self loadTopStories:block completion:NULL];
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


- (void)loadChild:(HNItem *)parent OnChildLoaded:(void (^)(HNItem *, HNItem *))block completion:(void (^)(BOOL isCancelled, NSArray *childs))completion
{
    NSMutableArray *childArray = [NSMutableArray new];
    for (Firebase *f in self.fbRefCache) {
        [f removeAllObservers];
    }
    [self.fbRefCache removeAllObjects];
    
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
                    [childArray addObject:item];
                    if (block) {
                        block(item, parent);
                    }
                }
                if ([array count] == idx + 1) {
                    if (completion) {
                        completion(NO, childArray);
                    }
                }
            } withCancelBlock:^(NSError* error){
                if (block) {
                    block(nil, parent);
                }
                if (completion) {
                    completion(YES, childArray);
                }
            }];
        }];
    }else{
        if (completion) {
            completion(NO, childArray);
        }
    }
}

- (void)loadChild:(HNItem*)parent OnChildLoaded:(void (^)(HNItem* item, HNItem* parent))block
{
    [self loadChild:parent OnChildLoaded:block completion:NULL];
}

@end
