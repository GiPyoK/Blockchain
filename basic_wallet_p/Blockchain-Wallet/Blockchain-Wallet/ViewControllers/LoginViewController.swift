//
//  LoginViewController.swift
//  Blockchain-Wallet
//
//  Created by Gi Pyo Kim on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var user: User?
    let transactionController = TransactionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        if let id = idTextField.text, !id.isEmpty {
            idTextField.layer.borderColor = UIColor.systemGray.cgColor
            user = User(id: id, balance: 0, transactions: [])
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            idTextField.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            if let mainVC = segue.destination as? MainViewController {
                mainVC.user = user
                mainVC.transactionController = transactionController
            }
        }
    }
    

}
