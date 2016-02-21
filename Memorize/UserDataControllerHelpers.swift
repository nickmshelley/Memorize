//
//  UserDataControllerHelpers.swift
//  Memorize
//
//  Created by Heather Shelley on 7/2/15.
//  Copyright (c) 2015 Mine. All rights reserved.
//

import Foundation
import Swiftification

extension UserDataController {
    
    func sampledCardsFromCards(cards: [Card], sampleNumber: Int, isNormalReview: Bool) -> [Card] {
        guard sampleNumber < cards.count else { return cards }
        var sampledCards = [Card]()
        let partitioned = cards.sort {
            let firstReviewState = isNormalReview ? $0.normalReviewState : $0.reverseReviewState
            let secondReviewState = isNormalReview ? $1.normalReviewState : $1.reverseReviewState
            if firstReviewState.numSuccesses == secondReviewState.numSuccesses {
                return firstReviewState.nextReviewDate.compare(secondReviewState.nextReviewDate) == .OrderedAscending
            } else {
                return firstReviewState.numSuccesses < secondReviewState.numSuccesses
            }
            }.sectionBy { isNormalReview ? String($0.normalReviewState.numSuccesses) : String($0.reverseReviewState.numSuccesses) }
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
    
    func numberOfOneDayNormalReviewCardsFromCards(cards: [Card]) -> Int {
        return cards.groupBy { $0.normalReviewState.numSuccesses }[1]?.count ?? 0
    }
    
}