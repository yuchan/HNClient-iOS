//
//  HNItem.m
//  HNPick
//
//  Created by Ohashi Yusuke on 1/28/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import "HNItem.h"
#import <UIKit/UIKit.h>
#import "GTMNSString+HTML.h"

@implementation HNItem
@synthesize kids = _kids;
@synthesize parent = _parent;
@synthesize depth = _depth;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self) {
        _childids = [aDecoder decodeObjectForKey:@"kids"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _itemID = [aDecoder decodeObjectForKey:@"id"];
        _depth = [aDecoder decodeIntegerForKey:@"depth"];
        _username = [aDecoder decodeObjectForKey:@"by"];
        _url = [aDecoder decodeObjectForKey:@"url"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _domain = [aDecoder decodeObjectForKey:@"domain"];
        _deleted = [aDecoder decodeBoolForKey:@"deleted"];
        _score = [aDecoder decodeObjectForKey:@"score"];
        _descendants = [aDecoder decodeObjectForKey:@"descendants"];
        _dead = [aDecoder decodeBoolForKey:@"dead"];
        [self initializeText:(NSString*)[aDecoder decodeObjectForKey:@"text"]];
        _updated = [aDecoder decodeObjectForKey:@"updated"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_childids forKey:@"kids"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeInteger:_depth forKey:@"depth"];
    [aCoder encodeObject:_itemID forKey:@"id"];
    [aCoder encodeObject:_username forKey:@"by"];
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_domain forKey:@"domain"];
    [aCoder encodeBool:_deleted forKey:@"deleted"];
    [aCoder encodeBool:_dead forKey:@"dead"];
    [aCoder encodeObject:_html forKey:@"text"];
    [aCoder encodeObject:_score forKey:@"score"];
    [aCoder encodeObject:_descendants forKey:@"descendants"];
    [aCoder encodeObject:_updated forKey:@"updated"];
}

// MARK: Public methods

- (id)initWithItemDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    _kids = [[NSMutableArray alloc] init];
    _depth = 0;
    _itemID = [dictionary objectForKey:@"id"];
    _childids = [dictionary objectForKey:@"kids"];
    _title = [dictionary objectForKey:@"title"];
    _username = [dictionary objectForKey:@"by"];
    _url = [dictionary objectForKey:@"url"];
    _type = [dictionary objectForKey:@"type"];
    _domain = [dictionary objectForKey:@"domain"];
    _score = [dictionary objectForKey:@"score"];
    _descendants = [dictionary objectForKey:@"descendants"];
    _updated = [dictionary objectForKey:@"time"];
    [self initializeText:[dictionary objectForKey:@"text"]];
    if ([dictionary objectForKey:@"deleted"]) {
        _deleted = [[dictionary objectForKey:@"deleted"] boolValue];
    }
    if ([dictionary objectForKey:@"dead"]) {
        _dead = [[dictionary objectForKey:@"dead"] boolValue];
    }
    return self;
}

- (void)addChildItem:(HNItem*)item
{
    [_kids addObject:item];
}

- (HNItemType)itemType
{
    NSString *type = self.type;
    if ([type isEqualToString:@"job"]) {
        return HNItemTypeJob;
    } else if ([type isEqualToString:@"comment"]) {
        return HNItemTypeComment;
    } else if ([type isEqualToString:@"poll"]) {
        return HNItemTypePoll;
    } else if ([type isEqualToString:@"pollopt"]) {
        return HNItemTypePollOpt;
    } else if ([type isEqualToString:@"story"] && (!self.url || self.url.length == 0)) {
        return HNItemTypeAsk;
    }
    
    return HNItemTypeStory;
}

// MARK: Private

- (void)initializeText:(NSString*)origText
{
    NSString* str = origText;
    if (str) {
        str = [str gtm_stringByUnescapingFromHTML];
        str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
        str = [self initializeUrlsAndReturnString:str];
    }
    _html = str;
}

- (NSString*)initializeUrlsAndReturnString:(NSString*)str
{
    if (!str) {
        return str;
    }

    NSUInteger index = 0;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSMutableArray* links = [[NSMutableArray alloc] init];
    while (index != NSNotFound) {
        NSRange range = [str rangeOfString:@"<a href=\"" options:NSLiteralSearch range:NSMakeRange(index, str.length - index)];
        index = range.location;
        if (index != NSNotFound) {

            NSRange subrange = [str rangeOfString:@"\"" options:NSLiteralSearch range:NSMakeRange(index + range.length, str.length - index - range.length)];
            NSRange endRange = [str rangeOfString:@"</a>" options:NSLiteralSearch range:NSMakeRange(subrange.location, str.length - subrange.location)];

            [links addObject:[str substringWithRange:NSMakeRange(index + range.length, subrange.location - index - range.length)]];
            [array addObject:[NSValue valueWithRange:NSMakeRange(index, range.length)]];
            index = endRange.length + endRange.location;
            [array addObject:[NSValue valueWithRange:NSMakeRange(subrange.location, endRange.length + endRange.location - subrange.location)]];
        }
        else {
            break;
        }
    }

    _urls = [links copy];

    NSInteger deletedlength = 0;
    for (NSValue* val in array) {
        NSRange range = [val rangeValue];
        range.location -= deletedlength;
        deletedlength += range.length;
        str = [str stringByReplacingCharactersInRange:range withString:@""];
    }

    return str;
}

@end
