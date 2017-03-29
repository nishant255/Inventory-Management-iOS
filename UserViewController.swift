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
    var id: String?
    let UM = UserModel()
    var user: NSDictionary?
    var loggedInUser: User?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var changeAdminButton: UIButton!

    @IBAction func changeAdminButtonPressed(_ sender: Any) {
        print("pressed changeAdminButton")
        print("user id is ",id!)
        var message = "hahaha"
        if admin == "User" {
            print("User admin status is User, lets change it to admin now")
            UM.makeAdmin(userId: id!) { (user) in
                print("user is: ",user)
                self.admin = "Admin"
                self.adminLabel.text = "Admin Status: \(self.admin!)"
                let alertForOrder = UIAlertController(title: "Changed admin status to Admin", message: nil, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                }
                alertForOrder.addAction(OKAction)
                self.present(alertForOrder, animated: true, completion: nil)
            }
        } else if admin == "Admin" {
            print("user is Admin, lets change him/her to User")
            UM.removeAdmin(userId: id!) { (user) in
                print("user is now: ",user)
                self.admin = "User"
                self.adminLabel.text = "Admin Status: \(self.admin!)"
                let alertForOrder = UIAlertController(title: "Changed admin status to User", message: nil, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                }
                alertForOrder.addAction(OKAction)
                self.present(alertForOrder, animated: true, completion: nil)
            }
        } else {
            print("user is probably super admin and you don't want to change anything")
            let alertForOrder = UIAlertController(title: "Can't change Super Admin status", message: nil, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            }
            alertForOrder.addAction(OKAction)
            self.present(alertForOrder, animated: true, completion: nil)
        }
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserViewController loaded with name: \(name), email: \(email), phone: \(phone), and admin: \(admin)")
        nameLabel.text = "Name: \(name!)"
        emailLabel.text = "Email: \(email!)"
        phoneLabel.text = "Phone: \(phone!)"
        adminLabel.text = "Admin Status: \(admin!)"
        loggedInUser = UM.getCoreDataUser()
        let loggedInUserAdmin = loggedInUser?.admin
        print("admin level is: ",loggedInUserAdmin!)
        if loggedInUserAdmin != 0 {
            changeAdminButton.isHidden = true
        }
    }
}
