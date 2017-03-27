//
//  DashboardModel.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class DashboardModel {
    func fetchDataFromServer (){
        let url = URL(string: urlHost + "products")
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var orders = [NSDictionary]()
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary
                        orders.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        let incomingShipment = DashboardSection(title: "Incoming Shipments", objects: orders)
                        self.dashboardSectionArray.append(incomingShipment)
                        self.dashboardTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
        })
        getPendingOrders.resume()
        let getProducts = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var products = [String]()
                    for product in jsonResult {
                        let productDict = product as! NSDictionary
                        products.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        let currentInventory = DashboardSection(title: "Current Inventory", objects: products)
                        self.dashboardSectionArray.append(currentInventory)
                        self.dashboardTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getProducts.resume()
    }
    
}
