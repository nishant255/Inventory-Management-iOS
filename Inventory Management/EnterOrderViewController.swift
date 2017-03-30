//
//  EnterOrderViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class EnterOrderViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var orderTableView: UITableView!
    var company: NSDictionary = [:]
    
    
    var productsSelected = [NSDictionary]()
    var shippingAddress: NSDictionary = [:]
    var newProdData = [NSMutableDictionary]()
    var rowBeingEdited : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func viewOrderButtonPressed(_ sender: UIButton) {
        
        if newProdData.count != productsSelected.count {
            self.errorAlert(title: "Order Error!", message: "Buy Price and Quantity Required for All Products")
        }
        
        for prod in newProdData {
            if String(describing: prod.value(forKey: "quantity")!) == "" || String(describing: prod.value(forKey: "buyPrice")!) == "" {
                self.errorAlert(title: "Order Error!", message: "Buy Price and Quantity Required for All Products")
            } else {
                if Int(prod.value(forKey: "quantity") as! String)! <= 0 || Int(prod.value(forKey: "buyPrice") as! String)! <= 0 {
                    self.errorAlert(title: "Order Error!", message: "Buy Price and Quantity Should be more than 0.")
                }
            }
        }
        
        let alertController = UIAlertController(title: "Add Shipping Address", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: {
            alert -> Void in
            let name = alertController.textFields![0] as UITextField
            let street = alertController.textFields![1] as UITextField
            let city = alertController.textFields![2] as UITextField
            let state = alertController.textFields![3] as UITextField
            let zipcode = alertController.textFields![4] as UITextField
            
            if name.text! == "" || street.text! == "" || city.text! == "" || state.text! == "" || zipcode.text! == "" {
                self.errorAlert(title: "Shipping Address Error!", message: "All the fields are required")
            } else {
                self.shippingAddress = [
                    "city": city.text!,
                    "name": name.text!,
                    "state": state.text!,
                    "street": street.text!,
                    "zipcode": zipcode.text!,
                ]
                self.performSegue(withIdentifier: "confirmOrderSegue", sender: (Any).self)
            }
        })
        
        alertController.addTextField { (textField : UITextField!) in
            
            textField.placeholder = "Enter Name"
            textField.tag = 1
        }
        alertController.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter Street"
            textField.tag = 2
        }
        alertController.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter City"
            textField.tag = 3
        }
        alertController.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter State"
            textField.tag = 4
        }
        alertController.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter Zip Code"
            textField.tag = 5
            textField.keyboardType = .numberPad
            
        }
        
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func errorAlert(title: String, message: String) {
        let alertForOrder = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { action in
        }
        alertForOrder.addAction(OKAction)
        self.present(alertForOrder, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing Segue")
        if segue.identifier == "confirmOrderSegue" {
            print("Prepared Segue")
            let controller = segue.destination as! ConfirmOrderViewController
            controller.productWithBuyPrice = newProdData
            controller.shippingAddress = shippingAddress
            controller.company = company
        }
    }

    
    
}



extension EnterOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTableViewCell", for: indexPath) as! OrderDetailsTableViewCell
        let product = productsSelected[indexPath.row]
        cell.productNameLabel.text = product["name"] as? String
        cell.productsBuyPrice.text = ""
        cell.productQuantity.text = ""
        cell.productQuantity.tag = Int("2\(indexPath.row)")!
        cell.productsBuyPrice.tag = Int("1\(indexPath.row)")!
        cell.productQuantity.delegate = self
        cell.productsBuyPrice.delegate = self
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {        
        let tagString = String(textField.tag)
        let row = Int(tagString.substring(with: 1..<tagString.characters.count))
        let fieldIdentifier = tagString.characters.first
        if row! >= newProdData.count {
            for _ in newProdData.count...row!{
                newProdData.append([
                    "quantity": "",
                    "buyPrice": "",
                    "product": [:]
                    ])
            }
        }
        let indexPath = IndexPath(row: row!, section: 0)
        let newProduct = newProdData[indexPath.row]
        newProduct.setObject(productsSelected[row!], forKey: "product" as NSCopying)
        if fieldIdentifier! == "1" {
            newProduct.setObject(textField.text!, forKey: "quantity" as NSCopying)
        } else if fieldIdentifier! == "2" {
            newProduct.setObject(textField.text!, forKey: "buyPrice" as NSCopying)
        }
        
    }
    
}

extension String {
    subscript (i: Int) -> Character {

        return self[self.index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }



}
