//
//  ConfirmOrderViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var sName: UILabel!
    @IBOutlet weak var sStreet: UILabel!
    @IBOutlet weak var sState: UILabel!
    @IBOutlet weak var sCity: UILabel!
    @IBOutlet weak var cZipCode: UILabel!
    
    var productWithBuyPrice = [NSMutableDictionary]()
    var shippingAddress: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sName.text = shippingAddress.value(forKey: "name") as? String
        sStreet.text = shippingAddress.value(forKey: "street") as? String
        sCity.text = shippingAddress.value(forKey: "city") as? String
        sState.text = shippingAddress.value(forKey: "state") as? String
        cZipCode.text = shippingAddress.value(forKey: "zipcode") as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirmOrderButtonPressed(_ sender: UIButton) {
        
    }

}

extension ConfirmOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productWithBuyPrice.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productHeaderCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let productwithBPandQ = productWithBuyPrice[indexPath.row - 1]
        let product = productwithBPandQ.value(forKey: "product") as! NSDictionary
        cell.productName.text = product.value(forKey: "name") as? String
        cell.productBuyPrice.text = productwithBPandQ.value(forKey: "buyPrice") as? String
        cell.productQuantity.text = productwithBPandQ.value(forKey: "quantity") as? String
        return cell

    }
}

