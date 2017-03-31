//
//  SelectProductsViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/28/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class SelectProductsViewController: UIViewController {
    
    var productsForSelectCompany = [NSDictionary]()
    var company: NSDictionary? = nil
    var productsSelected = [NSDictionary]()
    var newProduct: NSMutableDictionary = [:]
    let IM = InventoryModel()

    @IBOutlet weak var productsTableView: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addNewProductButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Shipping Address", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: {
            alert -> Void in
            let name = alertController.textFields![0] as UITextField
            
            if name.text! == "" {
                self.errorAlert(title: "Product Name Error", message: "Product Name is required.")
            }
            else if name.text!.characters.count < 2 {
                self.errorAlert(title: "Product Name Error", message: "Product Name Should be 2 or more Characters.")
            }
            else {
                self.newProduct = [
                    "name": name.text!,
                    "_company": self.company!,
                    "received": false
                ]
                self.IM.createNewProduct(newProduct: self.newProduct, completionHandler: { (success, message) in
                    if success {
                        self.errorAlert(title: message, message: nil)
                        self.productsTableView.reloadData()
                    } else {
                        self.errorAlert(title: "Product Error", message: message)
                    }
                })
            }
        })
        
        alertController.addTextField { (textField : UITextField!) in
            
            textField.placeholder = "Enter Product Name"
        }
        
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func addToOrderButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addToOrderSegue", sender: productsSelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if productsSelected.count == 0 {
            let alertForOrder = UIAlertController(title: nil, message: "Please Select at least 1 Product", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            }
            alertForOrder.addAction(OKAction)
            self.present(alertForOrder, animated: true, completion: nil)
        } else {
            if segue.identifier == "addToOrderSegue" {
                print(segue.destination)
                let controller = segue.destination as! EnterOrderViewController
                controller.productsSelected = self.productsSelected
                controller.company = self.company!
            }
        }
    }
    
    func errorAlert(title: String, message: String?) {
        let alertForOrder = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { action in
        }
        alertForOrder.addAction(OKAction)
        self.present(alertForOrder, animated: true, completion: nil)
    }
}

extension SelectProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsForSelectCompany.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = productsTableView.dequeueReusableCell(withIdentifier: "addNewOrderButton", for: indexPath)
            return cell
        }
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "companyProductCell", for: indexPath) as! SelectProductsTableViewCell
        let product = productsForSelectCompany[indexPath.row - 1]
        
        if productsSelected.contains(product){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        cell.productName.text = product["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            addNewProductButtonPressed(self)
        }
        let product = productsForSelectCompany[indexPath.row - 1]
        if productsSelected.contains(product){
            let toggle = productsSelected.index(of: product)
            productsSelected.remove(at: toggle!)
            tableView.reloadData()
        } else {
            productsSelected.append(product)
            tableView.reloadData()
        }
    }
}
