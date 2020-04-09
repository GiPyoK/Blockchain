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
    
    var user: User?
    var transactionController: TransactionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func displayBalance() {
        if let tc = transactionController {
            
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
