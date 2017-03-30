//
//  InventoryViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class InventoryViewController: UIViewController, UpdateDelegate, AddOrderDelegate {
    
    
    //=================================================================
    //                   VARIABLES AND OUTLETS
    //=================================================================
    
    let LM = LoginRegistrationModel()
    let IM = InventoryModel()
    
    
    
    //=================================================================
    //                        VIEW DID LOAD
    //=================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inventoryViewController loaded")
        inventoryTableView.dataSource = self
        inventoryTableView.delegate = self

//        IM.getAllProductsForInventory { (inventory) in
//            print("inventory is: ",inventory)
//            self.inventory = inventory
//            print(self.inventory)
//            self.inventoryTableView.reloadData()
//        }
        
    }
    
    //=================================================================
    //                        VIEW DID APPEAR
    //=================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear")
        IM.getAllProductsForInventory { (inventory) in
            print("inventory is: ",inventory)
            self.inventory = inventory
            print(self.inventory)
            self.inventoryTableView.reloadData()
        }

    }
    
    @IBOutlet weak var inventoryTableView: UITableView!
    
    var inventory = [NSDictionary]()
    
    
    //=================================================================
    //                           SIGN OUT
    //=================================================================
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        if LM.signOut(){
            print("Logged Out")
            performSegue(withIdentifier: "signOutSegue", sender: sender)
        }
    }
    

    func updateButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewOrderSegueFromInventory" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! SelectCompanyTableViewController
            controller.delegate = self
        } else  {
          let indexPath = sender as! IndexPath
        let product = inventory[indexPath.row]
        let controller = segue.destination as! UpdateSellPriceViewController
        let company = product["_company"] as! NSDictionary
        print("company is: ",company)
        controller.company = company["name"] as! String
        controller.product = product["name"] as! String
        controller.id = product["_id"] as! String
        controller.sellPrice = String(describing: product["sellPrice"]!)
        controller.updateDelegate = self
        }
    }
    
    func cancelButtonPressed(controller: SelectCompanyTableViewController) {
        dismiss(animated: true, completion: nil)
    }

}

//=================================================================
//                           EXTENSION
//=================================================================

extension InventoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell")! as! InventoryItemCustomCell
            let product = inventory[indexPath.row]
            let productCompany = product["_company"] as! NSDictionary
            cell.companyLabel.text = productCompany["name"] as? String
            cell.itemLabel.text = product["name"] as? String
            cell.priceLabel.text = "$\(String(describing: product["sellPrice"]!))"
            cell.quantityLabel.text = "Qty:\(String(describing: product["quantity"]!))"
            return cell
        }
       
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("pressed row at: ",indexPath.row)
        performSegue(withIdentifier: "SetSellPrice", sender: indexPath)
    }
    
}
