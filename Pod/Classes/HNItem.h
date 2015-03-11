//
//  HNItem.h
//  HNPick
//
//  Created by Ohashi Yusuke on 1/28/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNItem : NSObject <NSCoding>
@property (nonatomic) NSMutableArray* kids;
@property (nonatomic) HNItem* parent;
@property (nonatomic) NSInteger depth;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* username;
@property (nonatomic, readonly) NSString* html;
@property (nonatomic, readonly) NSString* url;
@property (nonatomic, readonly) NSString* domain;
@property (nonatomic, readonly) NSNumber* itemID;
@property (nonatomic, readonly) NSNumber* updated;
@property (nonatomic, readonly) NSNumber* score;
@property (nonatomic, readonly) NSArray* childids;
@property (nonatomic, readonly) NSArray* urls; //abstracted urls
@property (nonatomic, readonly) BOOL deleted;
@property (nonatomic, readonly) BOOL dead;

- (id)initWithItemDictionary:(NSDictionary*)dictionary;
- (void)addChildItem:(HNItem*)item;
@end
