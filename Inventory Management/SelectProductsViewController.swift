//
//  SelectProductsViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/28/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class SelectProductsViewController: UIViewController {
    
    var productsForSelectCompany = [NSDictionary]()
    var company: NSDictionary? = nil
    var productsSelected = [NSDictionary]()

    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addToOrderButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addToOrderSegue", sender: productsSelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToOrderSegue" {
            let controller = segue.destination as! EnterOrderViewController
            controller.productsSelected = self.productsSelected            
        }
    }
}

extension SelectProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsForSelectCompany.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = productsTableView.dequeueReusableCell(withIdentifier: "addNewOrderButton", for: indexPath)
            return cell
        }
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "companyProductCell", for: indexPath) as! SelectProductsTableViewCell
        let product = productsForSelectCompany[indexPath.row - 1]
        
        if productsSelected.contains(product){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        cell.productName.text = product["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
