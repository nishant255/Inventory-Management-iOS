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
    
    
    func createNewCompany(newCompany: NSDictionary, completionHandler: @escaping ((Bool, String) -> Void )) {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: newCompany, options: []) {
            let createCompanyURL = NSURL(string: "\(urlHost)companies")!
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
                                completionHandler(true, jsonResult["message"] as! String)
                            }
                        } else {
                            print("error")
                            let jsonerror = jsonResult["error"] as! NSDictionary
                            completionHandler(false, jsonerror["message"] as! String)
                        }
                    }
                } catch {
                    print(error)
                    completionHandler(false, "There was a error creating order")
                }
            }
            task.resume()
        }
    }
    
    /* func getAllCompanies() -> [[String]] {
        
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
        
    } */
    
    func getAllCompanies(completionHandler: @escaping (([NSDictionary]) -> Void)) {
        let allCompaniesURL = URL(string: urlHost + "companies")
        let urlRequest = URLRequest(url: allCompaniesURL!)
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
