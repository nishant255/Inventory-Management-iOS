//
//  User_Model.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import CoreData

class UserModel {
    
    func getCoreDataUser() -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var user: User?
        do {
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                user = result[0] as? User
            }
        } catch {
            print(error)
        }
        return user
    }
    
    func getServerUserFromEmail(email: String, completionHandler: @escaping ((NSDictionary) -> Void)) {
        let url = URL(string: urlHost + "user/getUser/email/" + (email))
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
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
    
    func makeAdmin(userId: String, completionHandler: @escaping ((NSDictionary) -> Void)) {
        print("about to try to change user to admin.  userID is ",userId)
        let url = URL(string: urlHost + "user/makeAdmin/" + userId)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
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
    
    func getAllUsers(completionHandler: @escaping (([NSDictionary]) -> Void)) {
        let allUsersURL = URL(string: urlHost + "users")
        let urlRequest = URLRequest(url: allUsersURL!)
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
    
    func removeAdmin(userId: String, completionHandler: @escaping ((NSDictionary) -> Void)) {
        print("about to try to remove user's admin.  userID is ",userId)
        let url = URL(string: urlHost + "user/removeAdmin/" + userId)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
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
