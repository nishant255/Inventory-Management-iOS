//
//  RegisterViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
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
            "first_name": firstNameInput.text,
            "last_name": lastNameInput.text,
            "email": emailInput.text,
            "password": passwordInput.text,
            "phone_number": Int(phoneInput.text!),
            ] as [String: Any]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            
            let host = "http://localhost:8000/"
            let url = NSURL(string: "\(host)user")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    print(jsonData)
//                    if let parseJSON = jsonData {
//                        let resultValue:String = parseJSON["success"] as! String;
//                        print("result: \(resultValue)")
//                        print(parseJSON)
//                    }
                } catch let error as NSError {
                    print(error)
                }        
            }          
            task.resume()
        }
        
    }
    
    
    
    
}
