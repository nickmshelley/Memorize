//
//  Date+Helpers.swift
//  Memorize
//
//  Created by Heather Shelley on 3/4/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import Foundation

extension Date {
    static func threeAMToday() -> Date {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        guard let hour = calendar.dateComponents([.hour], from: date).hour else { return date }
        let secondsToSubtract = hour < 3 ? 60 * 60 * 24 : 0
        return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date))?.addingTimeInterval((60 * 60 * 3 - secondsToSubtract)) ?? date
    }
}
