//
//  Transaction.swift
//  Blockchain-Wallet
//
//  Created by Gi Pyo Kim on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct Block: Codable {
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let sender: String
    let recipient: String
    let amount: Float
}
