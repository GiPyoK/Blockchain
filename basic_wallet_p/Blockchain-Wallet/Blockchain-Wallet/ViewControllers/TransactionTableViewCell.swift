//
//  TransactionTableViewCell.swift
//  Blockchain-Wallet
//
//  Created by Gi Pyo Kim on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var fromToLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var transaction: Transaction?
    var userID: String? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let transaction = transaction, let userID = userID else { return }
        
        if transaction.recipient == userID {
            fromToLabel.text = "From: \(transaction.sender)"
            fromToLabel.textColor = UIColor.systemBlue
            amountLabel.textColor = UIColor.systemBlue
        } else {
            fromToLabel.text = "To: \(transaction.recipient)"
            fromToLabel.textColor = UIColor.systemRed
            amountLabel.textColor = UIColor.systemRed
        }
        
        amountLabel.text = "\(transaction.amount)"
    }

}
