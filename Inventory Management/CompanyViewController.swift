//
//  CompanyViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.


import Foundation
import UIKit

class CompanyViewController: UIViewController {
    
//    ================================================
//                OUTLETS AND VARIABLES
//    ================================================
    
    var company: NSDictionary?
    var backDelegate: BackButtonDelegate?
    @IBOutlet weak var companyTableView: UITableView!
//    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backDelegate?.backButtonPressed(controller: self)
    }
    
//    ================================================
//                VIEW DID LOAD
//    ================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyTableView.dataSource = self
        companyTableView.delegate = self
        
        let companyName = company?["name"] as! String
        let email = company?["email"] as! String
        let phone = company?["phone"] as! String
        let addressDic = company?["address"] as! NSDictionary
        let city = addressDic["city"] as! String
        let state = addressDic["state"] as! String
        let street = addressDic["street"] as! String
        let zipcode = String(describing: addressDic["zipcode"]!)
        let address = "\(street), \(city) \(state), \(zipcode)"
        
        self.title = companyName
        emailLabel.text = "Email: \(email)"
        phoneLabel.text = "Phone: \(phone)"
        addressLabel.text = "Address: \(address)"
    }
}

//    ================================================
//                TABLEVIEW EXTENSION
//    ================================================

extension CompanyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let products = company?["products"] as! NSArray
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = companyTableView.dequeueReusableCell(withIdentifier: "ItemCell")
        let products = company?["products"] as! NSArray
        let product = products[indexPath.row] as! NSDictionary

        cell?.textLabel?.text = product["name"] as? String
        return cell!
    }

}
