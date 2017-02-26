//
//  CardViewerTableViewController.swift
//  Memorize
//
//  Created by Heather Shelley on 2/25/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

enum ViewType {
    case reviewing
    case notReviewing
}

class CardViewerTableViewController: UITableViewController {
    var viewType = ViewType.reviewing
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        switch viewType {
        case .reviewing:
            cards = UserDataController.shared().reviewingCards() as? [Card] ?? []
        case .notReviewing:
            cards = UserDataController.shared().notReviewingCards() as? [Card] ?? []
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(cards.count)")
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let card = cards[indexPath.row]
        UserDataController.shared().delete(card)
        if let index = cards.index(of: card) {
            cards.remove(at: index)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let card = self.cards[indexPath.row]
        cell.textLabel?.text = card.question
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ViewCardFromTable", sender: cards[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ViewCardFromTable", let card = sender as? Card, let vc = segue.destination as? CardViewerViewController else { return }
        
        vc.existingCard = card
    }
}
