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
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var placedOnLabel: UILabel!
    @IBOutlet weak var receivedOnLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    
    
    
    var orderNumber: String?
    var company: String?
    var placedOn: String?
    var receivedOn: String?
    var products: [NSDictionary]?
    var order: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderViewController loaded with order Number: \(orderNumber!), company: \(company!), placedOn: \(placedOn!), receivedOn: \(receivedOn!), and products: \(products!), and order: \(String(describing: order)) ")
        productsTableView.dataSource = self
        productsTableView.delegate = self
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

        
        
        
        orderNumberLabel.text = "Or der #: \(orderNumber!)"
        companyLabel.text = "Company: \(company!)"
        
    }
    
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        
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
