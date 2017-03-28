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
        print("OrderViewController loaded with order Number: \(orderNumber!), company: \(company!), placedOn: \(placedOn!), receivedOn: \(receivedOn!), and products: \(products!), and order: \(order) ")
        
//        let dateFormatter = DateFormatter()
//        let splitDate = dateString.components(separatedBy: "T")
//        if splitDate.count > 0 {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let orderDate = dateFormatter.date(from: splitDate[0])
//        }

//        let date = dateFormatter.st
        orderNumberLabel.text = "Order #: \(orderNumber!)"
        companyLabel.text = "Company: \(company!)"
        placedOnLabel.text = "Placed on: \(placedOn!)"
        receivedOnLabel.text = "Received on: \(receivedOn!)"
        
    }
}
