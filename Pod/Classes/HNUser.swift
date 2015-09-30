//
//  HNUser.swift
//  Pods
//
//  Created by Ohashi, Yusuke a on 9/30/15.
//
//

import UIKit

class HNUser: NSObject {
    var name: String = ""
    var karma: Int = 0
    var about: String = ""
    var created: Int = 0
    
    init(itemDictionary:NSDictionary) {
        super.init()
        self.name = itemDictionary.objectForKey("id") as! String
        self.karma = (itemDictionary.objectForKey("karma") as! NSNumber).integerValue
        var str = itemDictionary.objectForKey("about") as! NSString
        str = str.stringByReplacingOccurrencesOfString("<p>", withString: "\n\n")
        self.about = str as String
        self.created = (itemDictionary.objectForKey("created") as! NSNumber).integerValue
    }
}
