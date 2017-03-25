//
//  DashboardViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var orders = [NSDictionary]()
    var products = [String]()
    
    @IBOutlet weak var dashboardTableView: UITableView!
    
    var sections: [DashboardSection] = DashboardSectionData().getDashboardData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dashboard Loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].heading
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if tableView == self.incomingShipmentsTableView {
//            let cell = incomingShipmentsTableView.dequeueReusableCell(withIdentifier: "shipmentCell", for: indexPath) as! IncomingShipmentTableViewCell
//            let reciepient = orders[indexPath.row].value(forKey: "recipient") as! NSDictionary
//            let data_recipient = reciepient.value(forKey: "data") as! NSDictionary
//            cell.emailLabel.text = data_recipient.value(forKey: "email") as? String
//            let orderQuantity = String(describing: orders[indexPath.row].value(forKey: "numProducts")!)
//            cell.quantityLabel.text = orderQuantity 
//            let dateString = String(describing: orders[indexPath.row].value(forKey: "createdAt")!)
//            let dateFormatter = DateFormatter()
//            let splitDate = dateString.components(separatedBy: "T")
//            if splitDate.count > 0 {
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let orderDate = dateFormatter.date(from: splitDate[0])
//                cell.dateLabel.text = dateFormatter.string(from: orderDate!)
//            }
//            return cell
//        }
//        
//        
//        let cell = pendingOrdersview.dequeueReusableCell(withIdentifier: "pendingOrderCell", for: indexPath) as! PendingOrdersTableViewCell
//        cell.productName.text = products[indexPath.row]
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        if sections[indexPath.section].items[indexPath.row] is [NSDictionary] {
            print("NS Dictionary")
        } else if sections[indexPath.section].items[indexPath.row] is [String] {
            print("String")
        }
        return cell
        
    }        

}
