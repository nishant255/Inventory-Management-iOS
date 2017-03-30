//
//  OrderViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/28/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class OrderViewController: UIViewController {
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var placedByLabel: UILabel!
    @IBOutlet weak var placedOnLabel: UILabel!
    
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var receivedOnLabel: UILabel!
    
    
    var orderNumber: String?
    var placedBy: String?
    var company: String?
    var placedOn: String?
    var receivedOn: String?
    var products: [NSDictionary]?
    var order: NSDictionary?
    var backDelegate: BackButtonDelegate?
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backDelegate?.backButtonPressed(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderViewController loaded with order Number: \(orderNumber!), company: \(company!), placedOn: \(placedOn!), receivedOn: \(receivedOn!), and products: \(products!), and order: \(String(describing: order)) ")
        productsTable.dataSource = self
        productsTable.delegate = self
        
        let dateFormatter = DateFormatter()
        let splitDate = placedOn?.components(separatedBy: "T")
        let splitDate2 = receivedOn?.components(separatedBy: "T")
        if (splitDate?.count)! > 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let orderDate = dateFormatter.date(from: (splitDate?[0])!)
            let PO = dateFormatter.string(from: orderDate!)
            placedOnLabel.text = "Placed on: \(PO)"
            print("PO is: ",PO)
        }
        if (splitDate2?.count)! > 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let orderDate = dateFormatter.date(from: (splitDate2?[0])!)
            let RO = dateFormatter.string(from: orderDate!)
            print("ro is: ",RO)
            receivedOnLabel.text = "Received on: \(RO)"
        }

        
        
        
        orderLabel.text = "Order #: \(orderNumber!)"
        navBar.title = company!
        placedByLabel.text = "Placed By: \(placedBy!)"
        
    }
    
    
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTable.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        
        let product = products![indexPath.row]
        let name = product["name"] as! String
        let buyPrice = String(describing: product["buyPrice"]!)
        let qty = String(describing: product["quantity"]!)

        
        cell.productLabel.text = name
        cell.buyPriceLabel.text = "$\(buyPrice)"
        cell.qtyLabel.text = "Qty: \(qty)"
        return cell
    }
}
