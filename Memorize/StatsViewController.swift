//
//  StatsViewController.swift
//  Memorize
//
//  Created by Nick Shelley on 12/17/16.
//  Copyright © 2016 Mine. All rights reserved.
//

import UIKit

fileprivate struct StatsRow {
    let leftText: String
    let middleText: String?
    let rightText: String
}

fileprivate struct StatsInfo {
    let reviewLevel: Int
    let dayDifference: Int
    let total: Int
    let needsReview: Int
}

class StatsViewController: UITableViewController {
    var reviewType = ReviewType.normal
    
    private var sections = [[StatsRow]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = createSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sections = createSections()
        tableView.reloadData()
    }
    
    private func createSections() -> [[StatsRow]] {
        guard let reviewingCards = (UserDataController.shared().reviewingCards() as? [Card]) else { return [] }
        
        let reviewStates: [ReviewState]
        switch reviewType {
        case .normal:
            reviewStates = reviewingCards.map({ $0.normalReviewState! }).sorted { $0.numSuccesses < $1.numSuccesses }
        case .reverse:
            reviewStates = reviewingCards.map({ $0.reverseReviewState! }).sorted { $0.numSuccesses < $1.numSuccesses }
        }
        
        let reviewStateSections = reviewStates.sectioned { $0.numSuccesses }
        let rowInfos: [StatsInfo] = reviewStateSections.map { header, items in
            let total = items.count
            let dayDifference = items[0].dayDifference()
            let needsReview = items.filter { $0.needsReview() }.count
            return StatsInfo(reviewLevel: Int(header), dayDifference: dayDifference, total: total, needsReview: needsReview)
        }
        
        let totalCards = rowInfos.map { $0.total }.reduce(0, +)
        let readyCards = rowInfos.map { $0.needsReview }.reduce(0, +)
        let averagePerDay = rowInfos.reduce(0) { $0 + $1.total / $1.dayDifference }
        
        let firstSection = [StatsRow(leftText: "Total Cards:", middleText: nil, rightText: "\(totalCards)"),
                            StatsRow(leftText: "Cards Ready To Review:", middleText: nil, rightText: "\(readyCards)"),
                            StatsRow(leftText: "Average per Day:", middleText: nil, rightText: "\(averagePerDay)")]
        
        let secondSection = [StatsRow(leftText: "Level (Day Diff)", middleText: "Total", rightText: "Needs Review")] + rowInfos.map { StatsRow(leftText: "\($0.reviewLevel) (\($0.dayDifference))", middleText: "\($0.total)", rightText: "\($0.needsReview)") }
        
        return [firstSection, secondSection]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ThreeColumnTableViewCell else { return UITableViewCell() }
        
        let row = sections[indexPath.section][indexPath.row]
        cell.leftLabel?.text = row.leftText
        cell.middleLabel?.text = row.middleText
        cell.rightLabel?.text = row.rightText
        
        return cell
    }
}
