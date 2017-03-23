//
//  UsersViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class UsersViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
        usersTableView.delegate = self
        print("usersviewcontroller loaded")
    }

    @IBOutlet weak var usersTableView: UITableView!
    
    var users = [["Bob Sagat","Bob@Sagat.com","555-555-5556","Super Admin"],["Barack Obama","Barack@Obama.com","555-555-5557","Admin"]]
    
    
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        print("this is running")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")! as! UsersCustomCell
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.nameLabel.text = users[indexPath.row][0]
        cell.emailLabel.text = users[indexPath.row][1]
        cell.phoneLabel.text = users[indexPath.row][2]
        cell.adminLabel.text = users[indexPath.row][3]

        
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
}
