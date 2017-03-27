//
//  InventoryModel.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class InventoryModel{
    
    func getAllProducts() -> [String]{
        let url = URL(string: urlHost + "products")
        let session = URLSession.shared
        var products = [String]()
        let getProducts = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    for product in jsonResult {
                        let productDict = product as! NSDictionary
                        products.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        return products
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getProducts.resume()
        return products
    }
}
