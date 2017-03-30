//
//  EnterOrderTableViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/29/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class EnterOrderTableViewController: UITableViewController {

    var productsSelected = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsSelected.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == productsSelected.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewOrderCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTableViewCell", for: indexPath) as! OrderDetailsTableViewCell
            let product = productsSelected[indexPath.row]
            cell.productNameLabel.text = product["name"] as? String
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shippingAddress = UIAlertController()
    }
}
