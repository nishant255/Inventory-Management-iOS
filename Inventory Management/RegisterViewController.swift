//
//  RegisterViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    
    func checkCoreDataUser() -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedObjectContext.fetch(request)
            print(result)
            if result.count > 0 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func fetchUser() -> User{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var x: User?
        do {
            let result = try managedObjectContext.fetch(request)
            print(result)
            if result.count > 0 {
                x = (result[0] as! User)
            }
        } catch {
            print(error)
        }
        return x!
    }


    
    var currentUser: User?

    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cancelDelegate: CancelButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameInput.placeholder = "First Name"
        lastNameInput.placeholder = "Last Name"
        emailInput.placeholder = "Email"
        passwordInput.placeholder = "Password"
        passwordInput.isSecureTextEntry = true;
        phoneInput.placeholder = "Telephone"
        
    }
    
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!

    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelDelegate?.cancelButtonPressed(controller: self)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("pressed register")
        
        if firstNameInput.text == "" || lastNameInput.text == "" || emailInput.text == "" || passwordInput.text == "" || phoneInput.text == "" {
            print("all fields not filled out")
            return
        }
        
        
        
        let dict = [
            "first_name": firstNameInput.text!,
            "last_name": lastNameInput.text!,
            "email": emailInput.text!,
            "password": passwordInput.text!,
            "phone_number": Int(phoneInput.text!)!,
            ] as [String: Any]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            
            let url = NSURL(string: "\(urlHost)user")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                    return
                }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(jsonResult)
                        let success = jsonResult["success"] as! Bool
                        if success == true {
                            print("registered succesfully")
                            let user = jsonResult["user"] as! NSDictionary
                            let email = user["email"] as! String
                            let admin = user["admin"] as! Int
                            let fetchResult = self.checkCoreDataUser()
                            
                            if fetchResult == false {
                                let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext) as! User
                                newUser.email = email
                                newUser.isLoggedIn = true
                                newUser.admin = Int32(admin)
                                do {
                                    try self.managedObjectContext.save()
                                    print("register successful")
                                } catch {
                                    print(error)
                                }
                            } else if fetchResult == true {
                                let oldUser = self.fetchUser()
                                oldUser.email = email
                                oldUser.isLoggedIn = true
                                oldUser.admin = Int32(admin)
                                do {
                                    try self.managedObjectContext.save()
                                    print("register successful")
                                    self.performSegue(withIdentifier: "dashFromReg", sender: sender)
                                } catch {
                                    print(error)
                                }
                            
                        } else {
                            print("registration not successfull \(jsonResult["error_messages"])")
                        }
                    }

                    print(String(describing: jsonData))

                    }} catch let error as NSError {
                    print(error)
                }        
            }          
            task.resume()
        }
        
    }
    
    
    
    
}
