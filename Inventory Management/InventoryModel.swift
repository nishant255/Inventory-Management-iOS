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
    
    func createNewProduct(newProduct: NSDictionary, completionHandler: @escaping ((Bool, String, NSDictionary?) -> Void )) {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: newProduct, options: []) {
            let createCompanyURL = NSURL(string: "\(urlHost)products")!
            let request = NSMutableURLRequest(url: createCompanyURL as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(jsonResult)
                        if jsonResult["success"] as! Bool {
                            DispatchQueue.main.async {
                                completionHandler(true, jsonResult["message"] as! String, jsonResult["result"] as! NSDictionary)
                            }
                        } else {
                            print("error")
                            let jsonerror = jsonResult["error"] as! NSDictionary
                            completionHandler(false, jsonerror["message"] as! String, nil)
                        }
                    }
                } catch {
                    print(error)
                    completionHandler(false, "There was a error creating Product", nil)
                }
            }
            task.resume()
        }
    }
    
    func getAllProductsforDashboard(completionHandler: @escaping (([String]) -> Void)){
        let url = URL(string: urlHost + "products/withSellPrice")
        let session = URLSession.shared
        var products = [String]()
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    print("Sending Inventory")
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
    
    func getAllProductsForInventory(completionHandler: @escaping (([NSDictionary]) -> Void)){
        print("get all products for inventory running")
        let url = URL(string: urlHost + "products/withSellPrice")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            
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
    
    func getAllProducts(completionHandler: @escaping (([NSDictionary]) -> Void)){
        let url = URL(string: urlHost + "products/forSale")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
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
    
    func updateSellPrice(update: NSDictionary, completionHandler: @escaping ((NSDictionary) -> Void)) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: update, options: []) {
            let updateSellPriceURL = NSURL(string: "\(urlHost)products/update")!
            let request = NSMutableURLRequest(url: updateSellPriceURL as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        DispatchQueue.main.async {
                            completionHandler(jsonResult)
                        }

                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }


}
