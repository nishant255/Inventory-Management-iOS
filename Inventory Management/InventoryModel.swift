//
//  InventoryModel.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class InventoryModel{
    
    let UM = UserModel()
    
    func getAllProducts(completionHandler: @escaping (([String]) -> Void)){
        let url = URL(string: urlHost + "products")
        let session = URLSession.shared
        var products = [String]()
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    for product in jsonResult {
                        let productDict = product as! NSDictionary
                        products.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        
                        completionHandler(products)
                    }
                }
            } catch {
                print(error)
            }
            
        })
        task.resume()
        
    }
    
    func recieveOrder(order: NSDictionary, completionHandler: @escaping ((Bool) -> Void)) {
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
                        if (try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary) != nil {
                            DispatchQueue.main.async {
                                completionHandler(true)
                            }
                        }
                    } catch {
                        print(error)
                        completionHandler(false)
                    }
                }
                task.resume()
            }

        }
    }
}
