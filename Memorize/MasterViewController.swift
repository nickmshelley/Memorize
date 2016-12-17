//
//  MasterViewController.swift
//  Memorize
//
//  Created by Nick Shelley on 12/17/16.
//  Copyright © 2016 Mine. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let idendifier = segue.identifier else { return }
        
        if let reviewViewController = segue.destination as? ReviewViewController {
            switch idendifier {
            case "NormalReview":
                reviewViewController.reviewType = .normal
            case "ReverseReview":
                reviewViewController.reviewType = .reverse
            default:
                break
            }
        }
        
        if let cardViewerController = segue.destination as? CardViewerTableViewController {
            switch idendifier {
            case "Reviewing":
                cardViewerController.viewType = .reviewing
            case "NotReviewing":
                cardViewerController.viewType = .notReviewing
            default:
                break
            }
        }

    }
    
}
