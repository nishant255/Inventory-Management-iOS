//
//  OrderModel.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class OrderModel {
    func getPendingOrders() -> [NSDictionary] {
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        var orders = [NSDictionary]()
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary
                        orders.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        return orders
                    }
                }
            } catch {
                print(error)
            }
        })
        getPendingOrders.resume()
        return orders
    }
}
