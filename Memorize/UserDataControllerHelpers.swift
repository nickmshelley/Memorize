//
//  UserDataControllerHelpers.swift
//  Memorize
//
//  Created by Heather Shelley on 7/2/15.
//  Copyright (c) 2015 Mine. All rights reserved.
//

import Foundation

extension UserDataController {
    
    func sampledCardsFromCards(cards: [Card], sampleNumber: Int, isNormalReview: Bool) -> [Card] {
        var sampledCards = [Card]()
        var partitioned = cards.sorted {
            let firstReviewState = isNormalReview ? $0.normalReviewState : $0.reverseReviewState
            let secondReviewState = isNormalReview ? $1.normalReviewState : $1.reverseReviewState
            if firstReviewState.numSuccesses == secondReviewState.numSuccesses {
                return firstReviewState.nextReviewDate < secondReviewState.nextReviewDate
            } else {
                return firstReviewState.numSuccesses < secondReviewState.numSuccesses
            }
            }.partitionBy { isNormalReview ? $0.normalReviewState.numSuccesses : $0.reverseReviewState.numSuccesses }
        while sampledCards.count < sampleNumber {
            for dayArray in partitioned {
                if sampledCards.count < sampleNumber {
                    sampledCards.append(dayArray[0])
                }
            }
            partitioned = partitioned.mapFilter { $0.count > 1 ? $0.tail($0.count - 1) : nil }
        }
        
        return sampledCards
    }
    
}