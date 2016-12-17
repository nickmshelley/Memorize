//
//  AppDelegate.swift
//  Memorize
//
//  Created by Heather Shelley on 7/19/15.
//  Copyright (c) 2015 Mine. All rights reserved.
//

import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let defaults = UserDefaults.standard
        let hasDoneInitialImport = defaults.bool(forKey: "initialImportDone")
        if !hasDoneInitialImport {
            UserDataController.shared().importInitialData()
        }
        defaults.set(true, forKey: "initialImportDone")
        defaults.synchronize()
        importSharedCards()
    }
    
    fileprivate func importSharedCards() {
        if let sharedDefaults = UserDefaults(suiteName: "group.mine.memorize"), let sharedContent = sharedDefaults.array(forKey: "sharedContent") as? [[String: String]] {
            for elements in sharedContent {
                if let ref = elements["ref"], let text = elements["text"] {
                    let card = Card()
                    let parts = ref.components(separatedBy: ":")
                    if parts.count == 2 {
                        card.question = parts[0] + ": " + parts[1]
                    } else {
                        card.question = ref
                    }
                    
                    card.answer = text.components(separatedBy: "\n").map { "  " + $0 }.joined(separator: "\n")
                    card.synchronize()
                }
            }
            
            sharedDefaults.set([], forKey: "sharedContent")
            sharedDefaults.synchronize()
        }
    }
}
