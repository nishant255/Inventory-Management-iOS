//
//  Company_Model.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import CoreData

class CompanyModel {
    
    func getAllCompanies() -> [[String]] {
        
        let url = NSURL(string: urlHost+"companies")
        let session = URLSession.shared
        var companies = [[String]]()
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do {
                print("in the do")
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    
                    
                    print("result is =====>",jsonResult)
                    
                    print(jsonResult.count)
                    for var i in 0..<jsonResult.count {
                        let company = jsonResult[i] as! NSDictionary
                        let id = String(describing: company["_id"]!)
                        let name = company["name"] as! String
                        let email = company["email"] as! String
                        let phone = company["phone"] as! String
                        let addressDict = company["address"] as! NSDictionary
                        var address = ""
                        address += "\(addressDict["street"]!), \(addressDict["city"]!), \(addressDict["state"]!), \(addressDict["zipcode"]!)"
                        let itemArray = [name,email,phone,address,id]
                        companies.append(itemArray)
                        DispatchQueue.main.async {
//                            self.companiesTableView.reloadData()
                            return companies
                        }
                    }
                }
            } catch {
                print("in the catch")
                print(error)
            }
        })
        task.resume()
        print("I happen before the response!")
        return companies
        
    }
}
