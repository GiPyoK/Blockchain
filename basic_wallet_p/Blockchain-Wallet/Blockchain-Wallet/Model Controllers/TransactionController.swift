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
                let chain = try JSONDecoder().decode(Chain.self, from: data)
                let blocks = chain.chain
                self.transactions = []
                for block in blocks {
                    let serverTransactions = block.transactions
                    for transaction in serverTransactions{
                        self.transactions.append(transaction)
                    }
                }
                completion(nil)
                return
            } catch {
                print(error)
                print("Could not decode json")
                completion(.badDecode)
            }
        }.resume()
    }
    
    func getUserTransaction(userID: String) -> [Transaction] {
        let userID = userID.trimmingCharacters(in: .newlines)
        var transactions: [Transaction] = []
        for transaction in self.transactions {
            if transaction.sender == userID || transaction.recipient == userID {
                transactions.append(transaction)
            }
        }
        return transactions
    }
    
    func calculateUserBalance(user: User) -> Float {
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
        
        return receivedAmount - sentAmount
    }
}
