//
//  UpdateSellPriceViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/30/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class UpdateSellPriceViewController: UIViewController {
//    ===============================================================
//                    VARIABLES AND OUTLETS
//    ===============================================================

    var id: String?
    var company: String?
    var product: String?
    var sellPrice: String?
    let IM = InventoryModel()
    var backDelegate: BackButtonDelegate?
    
    @IBOutlet weak var navBar: UINavigationItem!
    var updateDelegate: UpdateDelegate?

    @IBOutlet weak var companyLabel: UILabel!

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var sellPriceTextField: UITextField!
    
    
    //    ===============================================================
    //                    BACK BUTTON
    //    ===============================================================

    
    @IBAction func backButtonPressed(_ sender: Any) {
        backDelegate?.backButtonPressed(controller: self)
        
    }
    
    //    ===============================================================
    //                    VIEW DID LOAD
    //    ===============================================================

    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyLabel.text = company!
        productLabel.text = product!
        sellPriceTextField.text = sellPrice!
        let IM = InventoryModel()
//        navBar.title = "Update Sell Price"
        sellPriceTextField.keyboardType = UIKeyboardType.decimalPad
    }
    
    
    //    ===============================================================
    //                    UPDATE BUTTON
    //    ===============================================================

    
    @IBAction func updateButtonPressed(_ sender: Any) {
        print("pressed update button with sellPrice of: \(sellPriceTextField.text!)")
        if sellPriceTextField.text == "" {
            print("nothing in the text field")
            return
        }
        let sellPriceNum = Int(sellPriceTextField.text!)
        print("sell price as a num is: ",sellPriceNum!)
        if sellPriceNum! < 0 {
            print("sell price is below 0, not good, not good at all...")
            return
        }
        let update = [
            "_id": self.id!,
            "sellPrice": self.sellPriceTextField.text!
            ] as [String : String]
        print("Updating Sell Price")
        
        self.IM.updateSellPrice (update: update as NSDictionary, completionHandler: { (updatedProduct) in
            print("back with some json: ",updatedProduct)
            let alertForOrder = UIAlertController(title: "Updated Sell Price of \(self.company!): \(self.product!) to $\(self.sellPriceTextField.text!)", message: nil, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            }
            alertForOrder.addAction(OKAction)
            self.present(alertForOrder, animated: true, completion: nil)
//            self.updateDelegate?.updateButtonPressed(controller: self)
        })
    }
}
