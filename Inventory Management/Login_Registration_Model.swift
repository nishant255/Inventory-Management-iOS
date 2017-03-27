//
//  Login_Registration_Model.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class LoginRegistrationModel {
    
    let userModel = UserModel()
    
    func signOut() -> Bool {
        let currentUser = userModel.getCoreDataUser()
        currentUser?.isLoggedIn = false
        do{
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
    }
}
