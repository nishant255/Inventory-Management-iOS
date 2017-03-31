//
//  AddNewCompanyViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/30/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class AddNewCompanyViewController: UIViewController {
    
    weak var delegate: AddNewCompanyDelegate?

    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    
    let CM = CompanyModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let companyString = self.companyName.text
        let emailString = self.email.text
        let phoneString = self.phoneNumber.text
        let streetString = self.street.text
        let cityString = self.city.text
        let stateString = self.state.text
        let zipString = self.zipCode.text
        if companyString == "" || emailString == "" || phoneString == "" || streetString == "" || cityString == "" || stateString == "" || zipString == "" {
            self.errorAlert(title: "Save Error", message: "All the fields are required")
        } else if zipString!.characters.count != 5 {
            self.errorAlert(title: "Address Error", message: "Zip Code has to be 5 digits")
        } else if phoneString!.characters.count != 10 {
            self.errorAlert(title: "Phone Error", message: "Phone number has to be 10 digits")
        } else {
            let newCompany = [
            "name" : companyString!,
            "email" : emailString!,
            "phone" : phoneString!,
            "address" : [
                "street" : streetString,
                "city" : cityString,
                "state" : stateString,
                "zipcode" : zipString
                ]
            ] as [String : Any]
            CM.createNewCompany(newCompany: newCompany as NSDictionary) { (success, message) in
                if success {
                    let alertForOrder = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { action in
                        self.delegate?.saveButtonPressed(controller: self, newCompany: newCompany as NSDictionary)
                    }
                    alertForOrder.addAction(OKAction)
                    self.present(alertForOrder, animated: true, completion: nil)
                } else {
                    print("err")
                    print(message)
                    print(success)
                    DispatchQueue.main.async {
                        let alertForOrder = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { action in
                            
                        }
                        alertForOrder.addAction(OKAction)
                        self.present(alertForOrder, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func errorAlert(title: String?, message: String?) {
        let alertForOrder = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { action in
        }
        alertForOrder.addAction(OKAction)
        self.present(alertForOrder, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(controller: self)
    }
}
