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
    
    
}
