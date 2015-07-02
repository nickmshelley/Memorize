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
        var partitioned = isNormalReview ? cards.sorted{ $0.normalReviewState.numSuccesses < $1.normalReviewState.numSuccesses }.partitionBy { $0.normalReviewState.numSuccesses } : cards.sorted{ $0.reverseReviewState.numSuccesses < $1.reverseReviewState.numSuccesses }.partitionBy { $0.reverseReviewState.numSuccesses }
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