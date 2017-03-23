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
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedObjectContext.fetch(request)
            print(result)
            if result.count > 0 {
                currentUser = result[0] as! User
            }
        } catch {
            print(error)
        }
        
    }
    
    @IBOutlet weak var emailLabel: UITextField!
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        
        if (currentUser != nil) {
            emailLabel.text = currentUser?.email
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func registerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: Any.self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register"{
            
        let controller = segue.destination as! RegisterViewController
        controller.cancelDelegate = self
        }
    }


    func cancelButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        
    }
    

}

