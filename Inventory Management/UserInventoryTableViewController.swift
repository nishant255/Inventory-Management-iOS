//
//  UserInventoryTableViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/29/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class UserInventoryTableViewController: UITableViewController {
    
    //    ====================================================
    //              VARIABLES AND LABELS
    //    ====================================================
    
    var products = [NSDictionary]()
    let IM = InventoryModel()
    let LM = LoginRegistrationModel()
    
//    ====================================================
//                    VIEW DID LOAD
//    ====================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserInventoryTableViewController loaded")
        
        IM.getAllProducts { (products) in
            print("products are: ",products)
            self.products = products
            print(products)
            self.tableView.reloadData()
        }
    }
    
    //    ====================================================
    //                   MAKE CELLS
    //    ====================================================

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! InventoryItemCustomCell
        let product = products[indexPath.row]
        
        let company = product["_company"] as! NSDictionary
        let companyName = company["name"] as! String
        let qty = String(describing: product["quantity"]!)
        let price = String(describing: product["sellPrice"]!)
        let item = product["name"] as! String
        
        cell.companyLabel.text = companyName
        cell.itemLabel.text = item
        cell.priceLabel.text = "$\(price)"
        cell.quantityLabel.text = "Qty:\(qty)"
        return cell
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
    
}
