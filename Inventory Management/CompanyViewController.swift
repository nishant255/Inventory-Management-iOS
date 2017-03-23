//
//  CompanyViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.


import Foundation
import UIKit

class CompanyViewController: UIViewController {
    
    var companyItems = [["go to the moon","$100","500"],["CheeseBurgers","$10","5000"]]
    var backDelegate: BackButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTableView.dataSource = self
        companyTableView.delegate = self
    }
    
    @IBOutlet weak var companyTableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backDelegate?.backButtonPressed(controller: self)
    }
    
    
    
}
extension CompanyViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")! as! CompanyItemCustomCell
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.itemLabel.text = companyItems[indexPath.row][0]
        cell.priceLabel.text = companyItems[indexPath.row][1]
        cell.quantityLabel.text = "Qty: \(companyItems[indexPath.row][2])"
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
}
