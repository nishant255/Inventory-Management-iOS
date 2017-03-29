//
//  OrderModel.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class OrderModel {
    
    let UM = UserModel()
    
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
    
    func recieveOrder(order: NSDictionary, completionHandler: @escaping ((Bool, String) -> Void)) {
        let cduser = UM.getCoreDataUser()
        UM.getServerUserFromEmail(email: (cduser?.email)!) { (serverUser) in
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: serverUser, options: []) {
                let updateOrderUrl = NSURL(string: "\(urlHost)orders/receive/\(order.value(forKey: "_id")!)")!
                let request = NSMutableURLRequest(url: updateOrderUrl as URL)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print(jsonResult)
                            if jsonResult["success"] as! Bool {
                                DispatchQueue.main.async {
                            
                                    completionHandler(true, jsonResult["message"] as! String)
                                }
                            } else {
                                completionHandler(false, jsonResult["message"] as! String)
                            }
                        }
                    } catch {
                        print(error)
                        completionHandler(false, "There was a error recieving order")
                    }
                }
                task.resume()
            }
            
        }
    }
    func getReceivedOrders(completionHandler: @escaping (([NSDictionary]) -> Void)) {
        let incomingShipmentsURL = URL(string: urlHost + "orders/Received")
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
