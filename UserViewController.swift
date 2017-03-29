//
//  UserViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/28/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    
    var name: String?
    var email: String?
    var phone: String?
    var admin: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!

    @IBAction func changeAdminButtonPressed(_ sender: Any) {
        print("pressed changeAdminButton")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserViewController loaded")
        nameLabel.text = "Name: \(name!)"
        emailLabel.text = "Email: \(email!)"
        phoneLabel.text = "Phone: \(phone!)"
        adminLabel.text = "Admin Status: \(admin!)"
    }
}
