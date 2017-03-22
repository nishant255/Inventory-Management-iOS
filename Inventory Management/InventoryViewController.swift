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
        
    }
    
    @IBOutlet weak var inventoryTableView: UITableView!
    
    var inventory = [["Tropicana","orange juice","$2","650"]]
}

extension InventoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        print("making a cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell")! as! InventoryItemCustomCell
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.companyLabel.text = inventory[indexPath.row][0]
        cell.itemLabel.text = inventory[indexPath.row][1]
        cell.quantityLabel.text = inventory[indexPath.row][2]
        cell.priceLabel.text = inventory[indexPath.row][3]
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
}
