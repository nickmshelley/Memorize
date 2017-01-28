//
//  ReviewViewController.swift
//  Memorize
//
//  Created by Heather Shelley on 1/16/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    var reviewType: ReviewType = .normal
    
    @IBOutlet weak var questionLabel: UILabel?
    @IBOutlet var questionButton: UIButton?
    @IBOutlet weak var answerTextView: UITextView?
    @IBOutlet var answerButton: UIButton?
    @IBOutlet var correctButton: UIButton?
    @IBOutlet weak var undoButton: UIButton?
    @IBOutlet weak var editButton: UIBarButtonItem?
    @IBOutlet var missedButton: UIButton?
    private var cards = [Card]()
    private var currentCard: Card?
    private var undoStack = [UndoObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch reviewType {
        case .normal:
            cards = UserDataController.shared().todaysNormalReviewCards() as? [Card] ?? []
        case .reverse:
            cards = UserDataController.shared().todaysReverseReviewCards() as? [Card] ?? []
        }
        
        updateCurrentCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        let hasCurrentCard: Bool = currentCard != nil ? true : false
        switch reviewType {
        case .normal:
            title = "Review (\(cards.count))"
            questionButton?.isEnabled = false
            answerButton?.isEnabled = hasCurrentCard
            answerTextView?.isHidden = true
            answerTextView?.text = currentCard?.answer
        case .reverse:
            title = "Review Reverse (\(cards.count))"
            answerButton?.isEnabled = false
            questionButton?.isEnabled = hasCurrentCard
            questionLabel?.isHidden = true
            answerTextView?.text = currentCard?.answer.components(separatedBy: CharacterSet.decimalDigits).joined(separator: "")
        }
        
        questionLabel?.text = currentCard?.question
        editButton?.isEnabled = hasCurrentCard
        correctButton?.isEnabled = false
        missedButton?.isEnabled = false
        undoButton?.isEnabled = (undoStack.count > 0)
    }
    
    @IBAction func questionPressed(_ sender: Any) {
        questionLabel?.isHidden = false
        correctButton?.isEnabled = true
        missedButton?.isEnabled = true
    }
    
    @IBAction func answerPressed(_ sender: Any) {
        answerTextView?.isHidden = false
        correctButton?.isEnabled = true
        missedButton?.isEnabled = true
    }
    
    @IBAction func correctPressed(_ sender: Any) {
        guard let currentCard = currentCard else { return }
        
        undoStack.append(UndoObject(card: currentCard, correct: true))
        currentCard.updateCorrect(for: reviewType)
        if let index = cards.index(of: currentCard) {
            cards.remove(at: index)
        }
        updateCurrentCard()
    }
    
    @IBAction func missedPressed(_ sender: Any) {
        guard let currentCard = currentCard else { return }
        
        undoStack.append(UndoObject(card: currentCard, correct: false))
        currentCard.updateMissed(for: reviewType)
        updateCurrentCard()
    }
    
    @IBAction func undoPressed() {
        guard let undo = undoStack.popLast() else { return }
        
        let card = undo.card
        card.synchronize()
        if !cards.contains(where: { $0.cardID == card.cardID }) {
            cards.append(card)
        }
        currentCard = card
        if undo.correct {
            switch reviewType {
            case .normal:
                UserDataController.shared().decrementNormalCardsReviewedToday()
            case .reverse:
                UserDataController.shared().decrementReverseCardsReviewedToday()
            }
        }
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cardViewer = segue.destination as? CardViewerViewController else { return }
        cardViewer.existingCard = currentCard
    }
    
    func updateCurrentCard() {
        currentCard = cards.isEmpty ? nil : cards.random()
        self.updateUI()
    }
}
