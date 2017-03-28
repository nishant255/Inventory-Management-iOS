//
//  OrderModel.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class OrderModel {
    func getPendingOrders(completionHandler: @escaping (([NSDictionary]) -> Void)) {
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let urlRequest = URLRequest(url: incomingShipmentsURL!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    DispatchQueue.main.async {
                        completionHandler(jsonResult as! [NSDictionary])
                    }
                }
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
        
        
    }
}
