//
//  ViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/21/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CancelButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
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

