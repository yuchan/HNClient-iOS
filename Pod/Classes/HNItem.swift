//
//  HNItem.swift
//  Pods
//
//  Created by Ohashi, Yusuke a on 9/30/15.
//
//

import UIKit

class HNItem: NSObject {
    var kids:Array<HNItem>
    var parent:HNItem
    var depth:Int
    var title:String
    var username:String
    var url:String
    var html:String
    var domain:String
    var itemID:Int
    var updated:Int
    var score:Int
    var childids:NSArray
    var urls:NSArray
    var deleted:Bool
    var dead:Bool
    
    init(dictionary:NSDictionary) {
        super.init()
        self.kids =  Array<HNItem>()
        self.depth = 0
        self.itemID = (dictionary.objectForKey("id") as! NSNumber).integerValue
        self.childids = dictionary.objectForKey("kids") as! NSArray
        self.title = dictionary.objectForKey("title") as! String
        self.username = dictionary.objectForKey("by") as! String
        self.url = dictionary.objectForKey("url") as! String
        self.domain = dictionary.objectForKey("domain") as! String
        self.score = (dictionary.objectForKey("score") as! NSNumber).integerValue
        self.updated = (dictionary.objectForKey("time") as! NSNumber).integerValue
        
        initializeText((dictionary.objectForKey("text") as! NSString))
        
        if let deleteValue:NSNumber = dictionary.objectForKey("deleted") {
            self.deleted = deleteValue.boolValue
        } else {
            self.deleted = false
        }
        
        if let deadValue:NSNumber = dictionary.objectForKey("dead") {
            self.dead = deadValue.boolValue
        } else {
            self.dead = false
        }
    }
    
    func addChildItem(item:HNItem) {
        self.kids.append(item)
    }
    
    private func initializeText(text:NSString) {
        var result:String = ""
        if let str:NSString = text {
            result = str.stringByReplacingOccurrencesOfString("<p>", withString: "\n\n")
            result = initizlizeUrlsAndReturnString(result)
        }
//        str = text
//        if (str) {
//            str = [str gtm_stringByUnescapingFromHTML];
//            str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
//            str = [self initializeUrlsAndReturnString:str];
//        }
        _html = str;
    }
}
