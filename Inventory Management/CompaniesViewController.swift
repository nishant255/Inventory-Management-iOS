//
//  CompaniesViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class CompaniesViewController: UIViewController, BackButtonDelegate {
    

    func backButtonPressed(controller:UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companiesTableView.dataSource = self
        companiesTableView.delegate = self
        print("companiesviewcontroller loaded")
        
        let host = "http://localhost:8000/"
        
        
        let url = NSURL(string: host+"companies")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do {
                print("in the do")
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    
                    print("result is =====>",jsonResult)
                    
                    print(jsonResult.count)
                    for var i in 0..<jsonResult.count {
                        let company = jsonResult[i] as! NSDictionary
                        let id = String(describing: company["_id"]!)
                        let name = company["name"] as! String
                        let email = company["email"] as! String
                        let phone = company["phone"] as! String
                        let addressDict = company["address"] as! NSDictionary
                        var address = ""
                        address += "\(addressDict["street"]!), \(addressDict["city"]!), \(addressDict["state"]!), \(addressDict["zipcode"]!)"
                        let itemArray = [name,email,phone,address,id]
                        self.companies.append(itemArray)
                        DispatchQueue.main.async {
                            self.companiesTableView.reloadData()
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
    
    
    @IBOutlet weak var companiesTableView: UITableView!

    var companies = [[String]]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("identifier is =======>",segue.identifier)
        if segue.identifier == "logout" {
            return
        }
    
            let controller = segue.destination as! CompanyViewController
            controller.backDelegate = self
            if sender is String {
                controller.companyId = sender as! String?
        
        }
    }
    
        
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("indexPath is ",indexPath)
        let id = companies[indexPath.row][4]
        performSegue(withIdentifier: "viewCompanyItems", sender: id)
    }
    


    
}


    
extension CompaniesViewController: UITableViewDataSource, UITableViewDelegate {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        print("this is running")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell")! as! CompaniesCustomCell
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.companyNameLabel.text = companies[indexPath.row][0]
        cell.emailLabel.text = companies[indexPath.row][1]
        cell.phoneLabel.text = companies[indexPath.row][2]
        cell.addressLabel.text = companies[indexPath.row][3]
        // return cell so that Table View knows what to draw in each row
        return cell
    }


}
