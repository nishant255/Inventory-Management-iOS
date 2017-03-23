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
        
        let host = "http://localhost:8000/"
        
        
        let url = NSURL(string: host+"users")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do {
                print("in the do")
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    
                    print("result is =====>",jsonResult)
                    
                    print(jsonResult.count)
                    for var i in 0..<jsonResult.count {
                        let user = jsonResult[i] as! NSDictionary
                        var name = ""
                        name += "\(user["first_name"]!) \(user["last_name"]!)"
                        let email = user["email"] as! String
                        let phone = String(describing: user["phone_number"]!)
                        var adminNum = user["admin"] as! Int
                        print("admin num is ",adminNum)
                        var admin = ""
                        if adminNum == 0 {
                            admin = "Super Admin"
                        } else if adminNum == 1 {
                            admin = "Admin"
                        } else {
                            admin = "User"
                        }
                        let itemArray = [name,email,phone,admin]
                        self.users.append(itemArray)
                        DispatchQueue.main.async {
                            self.usersTableView.reloadData()
                        }
                    }
                }
            } catch {
                print("in the catch")
                print(error)
            }
        })
        task.resume()
        print("I happen before the response!")
        
        
        
        
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
