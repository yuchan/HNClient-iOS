//
//  HNItem.h
//  HNPick
//
//  Created by Ohashi Yusuke on 1/28/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HNItemType) {
    HNItemTypeStory,
    HNItemTypeAsk,
    HNItemTypeJob,
    HNItemTypeComment,
    HNItemTypePoll,
    HNItemTypePollOpt
};

@interface HNItem : NSObject <NSCoding>
@property (nonatomic) NSMutableArray* kids;
@property (nonatomic) HNItem* parent;
@property (nonatomic) NSInteger depth;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* username;
@property (nonatomic, readonly) NSString* html;
@property (nonatomic, readonly) NSString* url;
@property (nonatomic, readonly) NSString* domain;
@property (nonatomic, readonly) NSString* type;
@property (nonatomic, readonly) NSNumber* itemID;
@property (nonatomic, readonly) NSNumber* updated;
@property (nonatomic, readonly) NSNumber* score;
@property (nonatomic, readonly) NSNumber* descendants;
@property (nonatomic, readonly) NSArray* childids;
@property (nonatomic, readonly) NSArray* urls; //abstracted urls
@property (nonatomic, readonly) BOOL deleted;
@property (nonatomic, readonly) BOOL dead;

- (id)initWithItemDictionary:(NSDictionary*)dictionary;
- (void)addChildItem:(HNItem*)item;
- (HNItemType)itemType;
@end
