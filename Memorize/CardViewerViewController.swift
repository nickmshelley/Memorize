//
//  CardViewerViewController.swift
//  Memorize
//
//  Created by Heather Shelley on 2/25/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

class CardViewerViewController: UIViewController {
    var existingCard: Card?
    
    @IBOutlet weak var questionTextView: UITextView?
    @IBOutlet weak var answerTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionTap = UITapGestureRecognizer(target: self, action: #selector(questionTapped))
        questionTap.numberOfTapsRequired = 1
        questionTextView?.addGestureRecognizer(questionTap)
        let answerTap = UITapGestureRecognizer(target: self, action: #selector(answerTapped))
        answerTap.numberOfTapsRequired = 1
        answerTextView?.addGestureRecognizer(answerTap)
        questionTextView?.text = existingCard?.question ?? "Touch to edit question."
        answerTextView?.text = existingCard?.answer ?? "Touch to edit answer."
    }
    
    func questionTapped() {
        performSegue(withIdentifier: "TextEditorSegue", sender: "question")
    }
    
    func answerTapped() {
        performSegue(withIdentifier: "TextEditorSegue", sender: "answer")
    }
    
    func editQuestion(_ text: String) {
        if existingCard == nil {
            existingCard = Card()
        }
        existingCard?.updateQuestion(text)
        questionTextView?.text = text
    }
    
    func editAnswer(_ text: String) {
        if existingCard == nil {
            existingCard = Card()
        }
        existingCard?.updateAnswer(text)
        answerTextView?.text = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "TextEditorSegue", let type = sender as? String, let editor = segue.destination as? TextEditorViewController else { return }
        
        if (type == "question") {
            editor.existingText = self.existingCard?.question
            editor.didSave = { text in
                self.editQuestion(text)
            }
        } else {
            editor.existingText = self.existingCard?.answer
            editor.didSave = { text in
                self.editAnswer(text)
            }
        }
    }
}
