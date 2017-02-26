//
//  TextEditorViewController.swift
//  Memorize
//
//  Created by Heather Shelley on 2/25/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

class TextEditorViewController: UIViewController {
    var existingText: String?
    var didSave: (String) -> Void = { _ in }
    
    @IBOutlet weak var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.text = self.existingText ?? ""
        textView?.becomeFirstResponder()
    }
    
    @IBAction func cancelPressed() {
        dismiss(animated: true, completion: { _ in })
    }
    
    @IBAction func savePressed() {
        didSave(textView?.text ?? "")
        dismiss(animated: true, completion: nil)
    }
}
