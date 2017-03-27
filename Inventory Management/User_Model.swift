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
    
    func getServerUserFromEmail(email: String) -> NSDictionary {
        var returnedUser: NSDictionary? = nil
        let url = URL(string: urlHost + "user/getUser/email/" + (email))
        let session = URLSession.shared
        let getServerUser = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult)
                    DispatchQueue.main.async {
                        returnedUser = jsonResult
                        
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getServerUser.resume()
        
        return returnedUser!
    }
}
