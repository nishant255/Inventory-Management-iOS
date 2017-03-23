//
//  OrdersViewController.swift
//  Inventory Management
//
//  Created by Akash Jagannathan on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit



class OrdersViewController: UIViewController, UITableViewDataSource, OrderDetailViewControllerDelegate{
    
    var PendingOrderCustomCell = [
        0:   ["PlacedBy": "Salm",
                    "PlacedOn": "Monday",
                    "numProducts": 30],
        
        1:   ["PlacedBy": "Trash",
                    "PlacedOn": "Wednesday",
                    "numProducts": 29]
        ] as [Int : [String: Any]]
   
    var ReceivedOrderCustomCell = [2:
                                  ["PlacedBy": "JRock",
                                  "PlacedOn": "Monday",
                                  "ReceivedOn": "Tuesday",
                                  "numProducts": 750],
                                  3:
                                  ["PlacedBy": "RedRock",
                                  "PlacedOn": "Wednesday",
                                  "ReceivedOn": "Thursday",
                                  "numProducts": 17]
    ] as [Int : [String: Any]]
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
//
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // How should I create each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PendingOrderCustomCell", for: indexPath) as! PendingOrderCustomCell
            
            let x = PendingOrderCustomCell[indexPath.row]! as NSDictionary
            
            let text1 = x["PlacedBy"]! as! String
            cell.PlacedBy.text = "Placed By: \(text1)"
            
            let text2 = x["PlacedOn"]! as! String
            cell.PlacedOn.text = "Placed On: \(text2)"
            
            let text3temp = x["numProducts"]! as! Int
            let text3 = String(text3temp)
            cell.NumProducts.text = "Number of Products(s): \(text3)"
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedOrderCustomCell", for: indexPath) as! ReceivedOrderCustomCell
            
            let x = ReceivedOrderCustomCell[indexPath.row]! as NSDictionary
           
            let text1 = x["PlacedBy"]! as! String
            cell.PlacedBy.text = "Placed By: \(text1)"
            
            let text2 = x["PlacedOn"]! as! String
            cell.PlacedOn.text = "Placed On: \(text2)"
            
            let text3temp = x["numProducts"]! as! Int
            let text3 = String(text3temp)
            cell.numProducts.text = "Number of Products(s): \(text3)"
            
            let text4 = x["ReceivedOn"]! as! String
            cell.ReceivedOn.text = "Received On: \(text4)"
            
            return cell
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! OrderDetailViewController
        controller.delegate = self
    }
    
    func orderDetailViewController(by controller: OrderDetailViewController, didPressBackButton: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
