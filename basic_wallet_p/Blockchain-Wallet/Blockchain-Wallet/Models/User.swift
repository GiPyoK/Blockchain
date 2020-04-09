//
//  User.swift
//  Blockchain-Wallet
//
//  Created by Gi Pyo Kim on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var balance: Float
    var transactions: [Transaction]
}
