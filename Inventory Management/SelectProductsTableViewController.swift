//
//  SelectProductsTableViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class SelectProductsTableViewController: UITableViewController {
    
    var productsForSelectCompany = [NSDictionary]()
    var company: NSDictionary? = nil
    var productsSelected = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    



}

extension SelectProductsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productsForSelectCompany.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNewOrderButton", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyProductCell", for: indexPath) as! SelectProductsTableViewCell
        let product = productsForSelectCompany[indexPath.row - 1]
        
        if productsSelected.contains(product){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        cell.productName.text = product["name"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productsForSelectCompany[indexPath.row - 1]
        if productsSelected.contains(product){
            let toggle = productsSelected.index(of: product)
            productsSelected.remove(at: toggle!)
            tableView.reloadData()
        } else {
            productsSelected.append(product)
            tableView.reloadData()
        }
    }
}
