//
//  ViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/21/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, CancelButtonDelegate {
    
    var currentUser: User?
    
    func getUser() -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var x: User?
        do {
            let result = try managedObjectContext.fetch(request)
            print(result)
            if result.count > 0 {
                x = result[0] as! User
            }
        } catch {
            print(error)
        }
        return x
    }
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    
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
    
    func checkLogin() {
        
        
        if emailLabel.text == "" || passwordLabel.text == "" {
            return
        }
        
        
        let dict = [
            "email": emailLabel.text,
            "password": passwordLabel.text
            ] as [String: Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            
            let host = "http://54.183.235.45/"
            let url = NSURL(string: "\(host)user_login")!
            let request = NSMutableURLRequest(url: url as URL)
            print("got past request")
            request.httpMethod = "POST"
            print("got past post")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print("got past addValue")
            request.httpBody = jsonData
            print("got past httpBody")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                print("got past task")
                if error != nil{
                    print("error is =====>",error?.localizedDescription)
                    return
                }
                print("no errors at this point")
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("got past post")
                        print(jsonResult)
                        let success = jsonResult["success"] as! Bool
                        if success == true {
                            print("login succesfully")
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
                                var oldUser = self.getUser()!
                                oldUser.email = email
                                oldUser.isLoggedIn = true
                                oldUser.admin = Int32(admin)
                                do {
                                    try self.managedObjectContext.save()
                                    print("login successful")
                                    
                                    DispatchQueue.main.sync {
                                        self.dashboardAfterLogin()
                                    }
                                } catch {
                                    print(error)
                                }
                                
                            }}
                        else {
                            print("login not successfull \(jsonResult["error_messages"])")
                        }
                        
                        print(String(describing: jsonData))
                        
                    }} catch let error as NSError {
                        print(error)
                }
            }
            task.resume()
            
        }

    }

    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("login button was pressed")
        checkLogin()
    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchResult = self.checkCoreDataUser()
        if fetchResult {
            currentUser = getUser()! as! User
        }
        passwordLabel.isSecureTextEntry = true;

        
        if (currentUser != nil) {
            emailLabel.text = currentUser?.email
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "register", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register"{
            
        let controller = segue.destination as! RegisterViewController
        controller.cancelDelegate = self
        }
        if segue.identifier == "login"{

            print("Good")
        }
    }


    func cancelButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        passwordLabel.text = ""
        
        
    }
    
    func dashboardAfterLogin(){
        performSegue(withIdentifier: "login", sender: self)
    }
    

}

