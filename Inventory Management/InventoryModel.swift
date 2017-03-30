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
    
    func getAllProductsforDashboard(completionHandler: @escaping (([String]) -> Void)){
        let url = URL(string: urlHost + "products/withSellPrice")
        let session = URLSession.shared
        var products = [String]()
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    print("json result is ",jsonResult)
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
    
    func getAllProducts(completionHandler: @escaping (([NSDictionary]) -> Void)){
        let url = URL(string: urlHost + "products/forSale")
        let session = URLSession.shared
        var products = [String]()
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                    //                    print("json result is ",jsonResult)
                    //                    for product in jsonResult {
                    //                        let productDict = product as! NSDictionary
                    //                        products.append(productDict.value(forKey: "name") as! String)
                    //                    }
                    DispatchQueue.main.async {
                        
                        completionHandler(jsonResult)
                    }
                }
            } catch {
                print(error)
            }
            
        })
        task.resume()
        
    }

}
