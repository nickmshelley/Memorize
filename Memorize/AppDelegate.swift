//
//  AppDelegate.swift
//  Memorize
//
//  Created by Heather Shelley on 7/19/15.
//  Copyright (c) 2015 Mine. All rights reserved.
//

import Foundation

class SwiftTopLevel: NSObject {
    
    static func importSharedCards() {
        if let sharedDefaults = NSUserDefaults(suiteName: "group.mine.memorize"), sharedContent = sharedDefaults.arrayForKey("sharedContent") as? [[String: String]] {
            for elements in sharedContent {
                if let ref = elements["ref"], text = elements["text"] {
                    let card = Card()
                    let parts = ref.componentsSeparatedByString(":")
                    if parts.count == 2 {
                        card.question = parts[0] + ": " + parts[1]
                    } else {
                        card.question = ref
                    }
                    
                    card.answer = text.componentsSeparatedByString("\n").map { "  " + $0 }.joinWithSeparator("\n")
                    card.synchronize()
                }
            }
            
            sharedDefaults.setObject([], forKey: "sharedContent")
            sharedDefaults.synchronize()
        }
    }
    
}