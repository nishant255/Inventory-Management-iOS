//
//  UsersViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class UsersViewController: UIViewController, AddOrderDelegate, BackButtonDelegate {
    
    
    //=================================================================
    //                    VARIABLES AND LABELS
    //=================================================================
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var users = [NSDictionary]()
    let LM = LoginRegistrationModel()
    
    //=================================================================
    //                       VIEW DID APPEAR
    //=================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        let UM = UserModel()
        UM.getAllUsers { (UsersFromServer) in
            self.users = UsersFromServer
            self.usersTableView.reloadData()
        }
    }
    
    //=================================================================
    //                        VIEW DID LOAD
    //=================================================================
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        usersTableView.dataSource = self
        usersTableView.delegate = self
        print("usersviewcontroller loaded")
//        let UM = UserModel()
////        UM.getCoreDataUser()
//        
//        UM.getAllUsers { (UsersFromServer) in
//            self.users = UsersFromServer
//            self.usersTableView.reloadData()
//        }
    }
    
    //=================================================================
    //                           BACK BUTTON
    //=================================================================
    
    func backButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //=================================================================
    //                           SEGUE
    //=================================================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUser" {
            let indexPath = sender as! IndexPath
            let user = users[indexPath.row]
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! UserViewController;
            let firstName = user["first_name"] as! String
            let lastName = user["last_name"] as! String
            let name = "\(firstName) \(lastName)"
            controller.backDelegate = self
            controller.name = name
            controller.email = user["email"] as? String
            let phone = String(describing: user["phone_number"]!)
            print("phone is: ",phone)
            controller.phone = phone
            let userAdmin = user["admin"] as! Int
            if userAdmin == 0 {
                controller.admin = "Super Admin"
            } else if userAdmin == 1 {
                controller.admin = "Admin"
            } else {
                controller.admin = "User"
            }
            controller.id = user["_id"] as? String
        }
        if segue.identifier == "addNewOrderSegueFromUsers" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! SelectCompanyTableViewController
            controller.delegate = self
        }
    }
    
    //=================================================================
    //                           SIGN OUT
    //=================================================================
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        if LM.signOut(){
            print("Logged Out")
            performSegue(withIdentifier: "signOutSegue", sender: sender)
        }
    }
    
    //=================================================================
    //                        CANCEL BUTTON PRESSED
    //=================================================================
    
    
    func cancelButtonPressed(controller: SelectCompanyTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")!
        let user = users[indexPath.row]
        let firstName = user["first_name"] as! String
        let lastName = user["last_name"] as! String
        let name = "\(firstName) \(lastName)"
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "showUser", sender: indexPath)
    }
    
}
