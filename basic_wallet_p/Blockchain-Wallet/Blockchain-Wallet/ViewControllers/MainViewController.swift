//
//  MainViewController.swift
//  Blockchain-Wallet
//
//  Created by Gi Pyo Kim on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                if self.isViewLoaded { self.tableView.reloadData() }
            }
        }
    }
    var transactionController: TransactionController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func updateUser() {
        guard let tc = transactionController, var user = user else { return }
        tc.getFullChain { (error) in
            if let error = error {
                print(error)
            }
            
            let transactions = tc.getUserTransaction(userID: user.id)
            user.transactions = transactions
            let balance = tc.calculateUserBalance(user: user)
            self.user = User(id: user.id, balance: balance, transactions: transactions)
            self.displayBalance()
        }
    }
    
    func displayBalance() {
        guard let user = user else { return }
        DispatchQueue.main.async {
            self.balanceLabel.text = "\(user.id)'s Balance: \(user.balance)"
            self.reloadInputViews()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = user {
            return user.transactions.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionTableViewCell, let user = user else { return UITableViewCell() }
                
        cell.transaction = user.transactions[user.transactions.count - indexPath.row - 1]
        cell.userID = user.id.trimmingCharacters(in: .newlines)
        return cell
    }
    
    @IBAction func reload(_ sender: Any) {
        updateUser()
        tableView.reloadData()
    }
    
    @IBAction func signOut(_ sender: Any) {
        self.user = nil
        self.transactionController = nil
        navigationController?.popViewController(animated: true)
    }
}
