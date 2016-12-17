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
        if let firstExtensionItem = extensionContext?.inputItems.first as? NSExtensionItem, let inputText = firstExtensionItem.attributedContentText?.string {
            let lineComponents = inputText.components(separatedBy: "\n")
            if lineComponents.count > 1 {
                let ref = lineComponents[0]
                let verses = Array(lineComponents[1..<lineComponents.count]).filter { $0.characters.count > 0 }
                let text = verses.joined(separator: "\n")
                
                let elements: NSDictionary = ["ref": ref, "text": text]
                if let sharedDefaults = UserDefaults(suiteName: "group.mine.memorize") {
                    let sharedContent: NSMutableArray = NSMutableArray(array: sharedDefaults.array(forKey: "sharedContent") ?? [])
                    sharedContent.add(elements)
                    sharedDefaults.set(sharedContent, forKey: "sharedContent")
                    sharedDefaults.synchronize()
                } else {
                    assert(false, "Fail!!!!")
                }
            }
        }
    
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}
