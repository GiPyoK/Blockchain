//
//  TransactionController.swift
//  Blockchain-Wallet
//
//  Created by Gi Pyo Kim on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum HeaderNames: String {
    case contentType = "Content-Type"
}

enum NetworkingError: Error, Equatable {
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case statusCodeMessage(String)
    case badDecode
    case badEncode
    case noRepresentation
    case needRegister
    case error(String)
}


class TransactionController {
    
    var transactions: [Transaction] = []
    
    private let baseURL = URL(string: "http://localhost:5000")!
    
    func getFullChain(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        let requestURL = self.baseURL.appendingPathComponent("chain")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error getting full chain")
                completion(.serverError(error))
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion(.noData)
                return
            }
            
            // Decode full chain json
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let chain = json["chain"] as? [Block] {
                        for block in chain {
                            let serverTransactions = block.transactions
                            for transaction in serverTransactions{
                                self.transactions.append(transaction)
                            }
                        }
                    }
                    completion(nil)
                    return
                }
            } catch {
                print("Could not decode json")
                completion(.badDecode)
            }
        }
    }
    
    func getUserTransaction(user: inout User) {
        let userID = user.id.trimmingCharacters(in: .newlines)
        
        for transaction in transactions {
            if transaction.sender == userID || transaction.recipient == userID {
                user.transactions.append(transaction)
            }
        }
    }
    
    func calculateUserBalance(user: inout User) {
        let userID = user.id.trimmingCharacters(in: .newlines)
        
        var sentAmount: Float = 0
        var receivedAmount: Float = 0
        
        for transaction in user.transactions {
            if transaction.recipient == userID {
                receivedAmount += transaction.amount
            } else {
                sentAmount += transaction.amount
            }
        }
        
        user.balance = receivedAmount - sentAmount
    }
}
