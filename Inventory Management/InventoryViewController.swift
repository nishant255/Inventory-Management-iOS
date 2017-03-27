//
//  InventoryViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class InventoryViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inventoryViewController loaded")
        inventoryTableView.dataSource = self
        inventoryTableView.delegate = self
        
        
        let url = NSURL(string: urlHost+"products/withSellPrice")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do {
                print("in the do")
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    
                    print("result is =====>",jsonResult)
                    
                    print(jsonResult.count)
                    for var i in 0..<jsonResult.count {
                        var itemArray = [String]()
                        let item = jsonResult[i] as! NSDictionary
                        let company = item["_company"] as! NSDictionary
                        let companyName = company["name"] as! String
                        let itemName = item["name"] as! String
                        let quantity = String(describing: item["quantity"]!)
                        let sellPrice = String(describing: item["sellPrice"]!)
                        itemArray.append(companyName)
                        itemArray.append(itemName)
                        itemArray.append(quantity)
                        itemArray.append(sellPrice)
                        self.inventory.append(itemArray)
                        DispatchQueue.main.async {
                            self.inventoryTableView.reloadData()
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
    
    @IBOutlet weak var inventoryTableView: UITableView!
    
    var inventory = [["Tropicana","orange juice","650","2"]]
}

extension InventoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell")! as! InventoryItemCustomCell
            cell.companyLabel.text = inventory[indexPath.row][0]
            cell.itemLabel.text = inventory[indexPath.row][1]
            cell.quantityLabel.text = "Qty: \(inventory[indexPath.row][2])"
            cell.priceLabel.text = "$\(inventory[indexPath.row][3])"
            return cell
        }
       
    
    
}
