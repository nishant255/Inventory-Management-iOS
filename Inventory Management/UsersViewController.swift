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
    
    
    @IBAction func unwindToUsers(sender: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
        usersTableView.delegate = self
        print("usersviewcontroller loaded")
        
        
        let url = NSURL(string: urlHost+"users")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do {
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    
                    print("result is =====>",jsonResult)
                    
                    for var i in 0..<jsonResult.count {
                        let user = jsonResult[i] as! NSDictionary
                        var name = ""
                        name += "\(user["first_name"]!) \(user["last_name"]!)"
                        let email = user["email"] as! String
                        let phone = String(describing: user["phone_number"]!)
                        let adminNum = user["admin"] as! Int
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
                print(error)
            }
        })
        task.resume()
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        let user = users[indexPath.row]
        let controller = segue.destination as! UserViewController;
        controller.name = user[0]
        controller.email = user[1]
        controller.phone = user[2]
        controller.admin = user[3]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")!
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
            cell.textLabel?.text = users[indexPath.row][0]
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "showUser", sender: indexPath)
    }
    
}
