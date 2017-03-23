//
//  DashboardViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var incomingShipmentsTableView: UITableView!
    @IBOutlet weak var pendingOrdersview: UITableView!
    
    let urlHost = "http://54.183.235.45/"
    var orders = [NSDictionary]()
    var products = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dashboard Loaded")
        incomingShipmentsTableView.dataSource = self
        incomingShipmentsTableView.delegate = self
        pendingOrdersview.dataSource = self
        pendingOrdersview.delegate = self
        let url = URL(string: urlHost + "products")
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        let getProducts = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
            // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        for product in jsonResult {
                            let productDict = product as! NSDictionary
                            self.products.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        self.pendingOrdersview.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getProducts.resume()
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
            // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary
                        print(shipDict)
                        self.orders.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        self.incomingShipmentsTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        
        getPendingOrders.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.incomingShipmentsTableView {
            return orders.count
        }
        
        else if tableView == self.pendingOrdersview {
            return products.count
        }
        
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.incomingShipmentsTableView {
            let cell = incomingShipmentsTableView.dequeueReusableCell(withIdentifier: "shipmentCell", for: indexPath) as! IncomingShipmentTableViewCell
            let reciepient = orders[indexPath.row].value(forKey: "recipient") as! NSDictionary
            let data_recipient = reciepient.value(forKey: "data") as! NSDictionary
            cell.emailLabel.text = data_recipient.value(forKey: "email") as? String
            let orderQuantity = String(describing: orders[indexPath.row].value(forKey: "numProducts")!)
            cell.quantityLabel.text = orderQuantity 
            let dateString = String(describing: orders[indexPath.row].value(forKey: "createdAt")!)
            let dateFormatter = DateFormatter()
            let splitDate = dateString.components(separatedBy: "T")
            if splitDate.count > 0 {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let orderDate = dateFormatter.date(from: splitDate[0])
                cell.dateLabel.text = dateFormatter.string(from: orderDate!)
            }
            return cell
        }
        
        
        let cell = pendingOrdersview.dequeueReusableCell(withIdentifier: "pendingOrderCell", for: indexPath) as! PendingOrdersTableViewCell
        cell.productName.text = products[indexPath.row]
        return cell
        
    }

}
