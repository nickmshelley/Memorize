//
//  ShareViewController.swift
//  GLExt
//
//  Created by Heather Shelley on 7/19/15.
//  Copyright (c) 2015 Mine. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func didSelectPost() {
        if let firstExtensionItem = extensionContext?.inputItems.first as? NSExtensionItem, inputText = firstExtensionItem.attributedContentText?.string {
            let lineComponents = inputText.componentsSeparatedByString("\n")
            if lineComponents.count > 1 {
                let ref = lineComponents[0]
                let verses = Array(lineComponents[1..<lineComponents.count]).filter { count($0) > 0 }
                let text = "\n".join(verses)
                
                let elements: NSDictionary = ["ref": ref, "text": text]
                if let sharedDefaults = NSUserDefaults(suiteName: "group.mine.memorize") {
                    var sharedContent: NSMutableArray = NSMutableArray(array: sharedDefaults.arrayForKey("sharedContent") ?? [])
                    sharedContent.addObject(elements)
                    sharedDefaults.setObject(sharedContent, forKey: "sharedContent")
                    sharedDefaults.synchronize()
                } else {
                    assert(false, "Fail!!!!")
                }
            }
        }
    
        self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
    }

}
