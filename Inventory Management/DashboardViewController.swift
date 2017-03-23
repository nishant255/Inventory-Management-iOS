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
    
    let urlHost = "http://127.0.0.1:8000/"
    var orders = [1,2,3,4]
    var products = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dashboard Loaded")
        incomingShipmentsTableView.dataSource = self
        incomingShipmentsTableView.delegate = self
        pendingOrdersview.dataSource = self
        pendingOrdersview.delegate = self
        let url = URL(string: urlHost + "products")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
            // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
            do {
                print("ReQue")
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    print(jsonResult)
//                    if let results = jsonResult["results"] as? NSArray {
//                        print(cd .)
//                        for product in results {
//                            let productDict = product as! NSDictionary
//                            print(productDict)
////                            self.products.append(productDict["name"])
//                        }
//                    }
                }
            } catch {
                print(error)
            }
            
        })
        task.resume()
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
            let cell = incomingShipmentsTableView.dequeueReusableCell(withIdentifier: "shipmentCell", for: indexPath)
            return cell
        }
        
        
        let cell = pendingOrdersview.dequeueReusableCell(withIdentifier: "pendingOrderCell", for: indexPath)
        return cell
        
    }

}
