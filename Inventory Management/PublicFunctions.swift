//
//  PublicFunctions.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/25/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit
import CoreData

let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
public func getUser() -> User? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    var x: User?
    do {
        let result = try managedObjectContext.fetch(request)
        if result.count > 0 {
            x = result[0] as? User
        }
    } catch {
        print(error)
    }
    return x
}
    
public func getCurrentUser(email: String) -> NSDictionary {
    var returnedUser: NSDictionary? = nil
    let currentUser = getUser()
    let url = URL(string: urlHost + "user/getUser/email/" + (currentUser?.email)!)
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
