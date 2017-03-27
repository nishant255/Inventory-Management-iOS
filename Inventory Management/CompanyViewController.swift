//
//  CompanyViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.


import Foundation
import UIKit

class CompanyViewController: UIViewController {
    
    var companyItems = [[String]]()
    var backDelegate: BackButtonDelegate?
    var companyId: String?
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTableView.dataSource = self
        companyTableView.delegate = self
        
        let url = NSURL(string: urlHost+"companies/\(companyId!)")
        let session = URLSession.shared
        print("got to here")
        print(companyId!)
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do {
                print("in the do")
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    
                    print("result is =====>",jsonResult)
                    
                    print(jsonResult.count)
                    self.titleLabel.title = jsonResult["name"] as! String
                    
                    let items = jsonResult["products"] as! NSArray
                    for var i in 0..<items.count {
                        let item = items[i] as! NSDictionary
                        let name = item["name"] as! String
                        let price = String(describing: item["sellPrice"]!)
                        let quantity = String(describing: item["quantity"]!)
                        let itemArray = [name,price,quantity]
                        self.companyItems.append(itemArray)
                        DispatchQueue.main.async {
                            self.companyTableView.reloadData()
                        }
                    }
                }
            } catch {
                print("in the catch")
                print(error)
            }
        })
        task.resume()
        print("I happen before the response!")

        
        
        
    }
    
    @IBOutlet weak var companyTableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backDelegate?.backButtonPressed(controller: self)
    }
    
    
    
}
extension CompanyViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")! as! CompanyItemCustomCell
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.itemLabel.text = companyItems[indexPath.row][0]
        cell.priceLabel.text = companyItems[indexPath.row][1]
        cell.quantityLabel.text = "Qty: \(companyItems[indexPath.row][2])"
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
}
