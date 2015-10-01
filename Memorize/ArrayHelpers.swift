//
//  ArrayHelpers.swift
//  TaskRace
//
//  Created by Heather Shelley on 9/19/15.
//  Copyright © 2015 Mine. All rights reserved.
//

import Foundation

extension Array {
    
    func sectionBy(@noescape sectionFunction: (Element) -> String) -> [(title: String, items: [Element])] {
        var lastTitle = ""
        var currentGroup = [Element]()
        var allGroups = [(title: String, items: [Element])]()
        
        for item in self {
            let title = sectionFunction(item)
            if title == lastTitle {
                currentGroup.append(item)
            } else {
                if !currentGroup.isEmpty {
                    allGroups.append((title: lastTitle, items: currentGroup))
                }
                lastTitle = title
                currentGroup = [item]
            }
        }
        
        if !currentGroup.isEmpty {
            allGroups.append((title: lastTitle, items: currentGroup))
        }
        
        return allGroups
    }
    
    func partitionBy <T: Equatable> (cond: (Element) -> T) -> [Array] {
        var result = [Array]()
        var lastValue: T? = nil
        
        for item in self {
            let value = cond(item)
            
            if value == lastValue {
                let index: Int = result.count - 1
                result[index] += [item]
            } else {
                result.append([item])
                lastValue = value
            }
        }
        
        return result
    }
    
}