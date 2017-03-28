//
//  Login_Registration_Model.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

class LoginRegistrationModel {
    
    let UM = UserModel()
    
    func signOut() -> Bool {
        UM.getCoreDataUser()?.isLoggedIn = false
        do{
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    func checkLogin() -> Bool {
        if (UM.getCoreDataUser()?.isLoggedIn)! {
            return true
        }
        return false
    }
}
