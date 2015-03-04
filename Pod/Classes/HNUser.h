//
//  HNUser.h
//  HNBrowser
//
//  Created by Yusuke Ohashi on 2/27/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNUser : NSObject <NSCoding>
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSNumber* karma;
@property (nonatomic, readonly) NSString* about;
@property (nonatomic, readonly) NSNumber* created;
- (id)initWithItemDictionary:(NSDictionary*)dictionary;
@end
