//
//  DashboardViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // =================================================
    // ALL THE OUTLET AND CONTROLLER VARIABLE
    // =================================================
    
    @IBOutlet weak var dashboardTableView: UITableView!
    var dashboardSectionArray = [DashboardSection]()
    let userModel = UserModel()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(DashboardViewController.refreshControlMethod), for: .valueChanged)
        self.dashboardTableView.addSubview(refreshControl)
        fetchDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

    // =================================================
    //  ALL THE METHODS FOR CONTROLLER
    // =================================================
    
    // MARK -> Fetching Initital Data from Server
    
    func refreshControlMethod() {
        dashboardSectionArray = [DashboardSection]()
        fetchDataFromServer()
        refreshControl.endRefreshing()
        
    }
 
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK -> Number of Sections in Table
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections: \(dashboardSectionArray.count)")
        return dashboardSectionArray.count
    }
    
    // MARK -> Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dashboardSectionArray count:")
        print(dashboardSectionArray[section].items.count)
        if dashboardSectionArray[section].heading == "Incoming Shipments" {
            if dashboardSectionArray[section].items.count == 0 {
                return 1
            }
        }
        return dashboardSectionArray[section].items.count
    }
    
    // MARK -> Title for Each Section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dashboardSectionArray[section].heading
    }
    
    // MARK -> Data for Each Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK -> If No Incoming Shipments
        
        if dashboardSectionArray[indexPath.section].heading == "Incoming Shipments" {
            if dashboardSectionArray[indexPath.section].items.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noIncomingShipmentCell", for: indexPath)
                return cell
            }
        }
        
        // MARK -> Data for Incoming Shipments Cell
        
        if dashboardSectionArray[indexPath.section].items[indexPath.row] is NSDictionary {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingShipmentCell", for: indexPath) as! IncomingShipmentTableViewCell
            let order = dashboardSectionArray[indexPath.section].items[indexPath.row] as! NSDictionary
            let reciepient = order.value(forKey: "recipient") as! NSDictionary
            let data_recipient = reciepient.value(forKey: "data") as! NSDictionary
            cell.orderTitleLabel.text = data_recipient.value(forKey: "email") as? String
            let dateString = String(describing: (order).value(forKey: "createdAt")!)
            let dateFormatter = DateFormatter()
            let splitDate = dateString.components(separatedBy: "T")
            if splitDate.count > 0 {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let orderDate = dateFormatter.date(from: splitDate[0])
                cell.orderDateLabel.text = dateFormatter.string(from: orderDate!)
            }
            return cell
        }
        
        // MARK -> Data for Current Inventory Cell
        
        if dashboardSectionArray[indexPath.section].items[indexPath.row] is String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentInventoryProductCell", for: indexPath) as! CurrentInventoryTableViewCell
            cell.productLabel.text = dashboardSectionArray[indexPath.section].items[indexPath.row] as? String
            return cell
        }
        
        // MARK -> if None of the Condition Pass
        let cell = tableView.dequeueReusableCell(withIdentifier: "noIncomingShipmentCell", for: indexPath)
        return cell
    }
    
    // MARK -> Selection Each Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK -> Actionsheet for Recieving Order
        if dashboardSectionArray[indexPath.section].heading == "Incoming Shipments" {
            if dashboardSectionArray[indexPath.section].items.count > 0 {
                let alertController = UIAlertController(title: "Order Recieved?", message: nil, preferredStyle: .actionSheet)
                let recievedAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { action in
                    let incomingShipmentSection = self.dashboardSectionArray[indexPath.section]
                    let order = incomingShipmentSection.items[indexPath.row] as! NSDictionary
                    let orderId = order.value(forKey: "_id") as! String
                    let currentUser = self.userModel.getCoreDataUser()
                    let getUserURL = URL(string: urlHost + "user/getUser/email/" + (currentUser?.email)!)
                    let session = URLSession.shared
                    let getUserFromServer = session.dataTask(with: getUserURL!, completionHandler: {
                        data, response, error in
                        
                        do {
                            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                let user = jsonResult.value(forKey: "data")
                                print(jsonResult)
                                DispatchQueue.main.async {
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: user!, options: []) {
                                        let updateOrderUrl = NSURL(string: "\(urlHost)orders/receive/\(orderId)")!
                                        let request = NSMutableURLRequest(url: updateOrderUrl as URL)
                                        request.httpMethod = "POST"
                                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                        request.httpBody = jsonData
                                        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                                            do {
                                                if let jsonResultAfterUpdatingServer = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                                    print(jsonResultAfterUpdatingServer)
                                                    DispatchQueue.main.async {
                                                        print("Successfully Updated Order")
                                                    }
                                                }
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        task.resume()
                                        
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                    })
                    getUserFromServer.resume()
                    
                }
                
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { action in
                }
                
                alertController.addAction(recievedAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
