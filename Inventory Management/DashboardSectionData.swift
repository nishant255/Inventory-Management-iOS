//
//  DashboardSectionData.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/23/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class DashboardSectionData: DashboardViewController {
        
    
    func getDashboardData() -> [DashboardSection] {
        var dashboardSectionArray = [DashboardSection]()
        var items = [Any]()
        
        let url = URL(string: urlHost + "products")
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        let getProducts = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for product in jsonResult {
                        let productDict = product as! NSDictionary
                        items.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        let currentInventory = DashboardSection(title: "Current Inventory", objects: items)
                        dashboardSectionArray.append(currentInventory)
                        self.dashboardTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getProducts.resume()
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary                        
                        items.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        let incomingShipment = DashboardSection(title: "Incoming Shipments", objects: items)
                        dashboardSectionArray.append(incomingShipment)
                        self.dashboardTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        
        getPendingOrders.resume()
        return dashboardSectionArray
    }
}
