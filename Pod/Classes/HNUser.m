//
//  HNUser.m
//  HNBrowser
//
//  Created by Yusuke Ohashi on 2/27/15.
//  Copyright (c) 2015 Ohashi Yusuke. All rights reserved.
//

#import "HNUser.h"
#import "GTMNSString+HTML.h"

@implementation HNUser

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _karma = [aDecoder decodeObjectForKey:@"karma"];
        _about = [aDecoder decodeObjectForKey:@"about"];
        _created = [aDecoder decodeObjectForKey:@"created"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_karma forKey:@"karma"];
    [aCoder encodeObject:_about forKey:@"about"];
    [aCoder encodeObject:_created forKey:@"created"];
}

- (id)initWithItemDictionary:(NSDictionary*)itemDictionary
{
    self = [super init];
    if (self) {
        _name = [itemDictionary objectForKey:@"id"];
        _karma = [itemDictionary objectForKey:@"karma"];
        NSString* str = [itemDictionary objectForKey:@"about"];
        str = [str gtm_stringByUnescapingFromHTML];
        str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
        _about = str;
        _created = [itemDictionary objectForKey:@"created"];
        return self;
    }
    return nil;
}
@end
