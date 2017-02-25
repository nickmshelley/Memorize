//
//  UserDataControllerHelpers.swift
//  Memorize
//
//  Created by Nick Shelley on 7/2/15.
//  Copyright (c) 2015 Mine. All rights reserved.
//

import Foundation
import Swiftification

extension UserDataController {
    
    func sampledCardsFromCards(_ cards: [Card], sampleNumber: Int, isNormalReview: Bool) -> [Card] {
        guard sampleNumber < cards.count else { return cards }
        var sampledCards = [Card]()
        let partitioned = cards.sorted {
            let firstReviewState = isNormalReview ? $0.normalReviewState! : $0.reverseReviewState!
            let secondReviewState = isNormalReview ? $1.normalReviewState! : $1.reverseReviewState!
            if firstReviewState.numSuccesses == secondReviewState.numSuccesses {
                return firstReviewState.nextReviewDate.compare(secondReviewState.nextReviewDate) == .orderedAscending
            } else {
                return firstReviewState.numSuccesses < secondReviewState.numSuccesses
            }
            }.sectioned { isNormalReview ? String($0.normalReviewState.numSuccesses) : String($0.reverseReviewState.numSuccesses) }
        var currentIndex = 0
        while sampledCards.count < sampleNumber {
            for day in partitioned {
                if sampledCards.count < sampleNumber, let card = day.items[safe: currentIndex] {
                    sampledCards.append(card)
                }
            }
            currentIndex += 1
        }
        
        return sampledCards
    }
    
    func numberOfOneDayNormalReviewCardsFromCards(_ cards: [Card]) -> Int {
        return cards.grouped { $0.normalReviewState.numSuccesses }[1]?.count ?? 0
    }
    
}
