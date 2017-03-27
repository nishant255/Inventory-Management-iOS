//
//  DashboardTableViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/26/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController {
    
    var dashboardSectionArray = [DashboardSection]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADIN")
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        fetchDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refreshing")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var orders = [NSDictionary]()
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary
                        orders.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        var incomingShipment: DashboardSection
                        for section in self.dashboardSectionArray {
                            if section.heading == "Incoming Shipments" {
                                incomingShipment = section
                                incomingShipment.items = orders
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getPendingOrders.resume()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dashboardSectionArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dashboardSectionArray[section].heading == "Incoming Shipments" {
            if dashboardSectionArray[section].items.count == 0 {
                return 1
            }
        }
        return dashboardSectionArray[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dashboardSectionArray[section].heading
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK -> Actionsheet for Recieving Order
        if dashboardSectionArray[indexPath.section].heading == "Incoming Shipments" {
            if dashboardSectionArray[indexPath.section].items.count > 0 {
                let alertController = UIAlertController(title: "Order Recieved?", message: nil, preferredStyle: .actionSheet)
                let recievedAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { action in
                    let incomingShipmentSection = self.dashboardSectionArray[indexPath.section]
                    let order = incomingShipmentSection.items[indexPath.row] as! NSDictionary
                    let orderId = order.value(forKey: "_id") as! String
                    let currentUser = getUser()
                    let getUserURL = URL(string: urlHost + "user/getUser/email/" + (currentUser?.email)!)
                    let session = URLSession.shared
                    let getUserFromServer = session.dataTask(with: getUserURL!, completionHandler: {
                        data, response, error in
                        
                        do {
                            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                let user = jsonResult
                                print(jsonResult)
                                DispatchQueue.main.async {
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: user, options: []) {
                                        let updateOrderUrl = NSURL(string: "\(urlHost)orders/receive/\(orderId)")!
                                        let request = NSMutableURLRequest(url: updateOrderUrl as URL)
                                        request.httpMethod = "POST"
                                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                        request.httpBody = jsonData
                                        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                                            do {
                                                if (try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary) != nil {
                                                    DispatchQueue.main.async {
                                                        let alertController = UIAlertController(title: "Successfully Updated Order", message: nil, preferredStyle: .alert)
                                                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                                                            print("Successfully Updated Order")
                                                            self.fetchNewDataFromServer()
                                                            tableView.reloadData()
                                                        }
                                                        alertController.addAction(OKAction)
                                                        self.present(alertController, animated: true, completion: nil)
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
    
    // =================================================
    //  ALL THE METHODS FOR CONTROLLER
    // =================================================
    
    // MARK -> Fetching Initital Data from Server
    func fetchDataFromServer (){
        let url = URL(string: urlHost + "products")
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var orders = [NSDictionary]()
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary
                        orders.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        let incomingShipment = DashboardSection(title: "Incoming Shipments", objects: orders)
                        self.dashboardSectionArray.append(incomingShipment)
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
        })
        getPendingOrders.resume()
        let getProducts = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var products = [String]()
                    for product in jsonResult {
                        let productDict = product as! NSDictionary
                        products.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        let currentInventory = DashboardSection(title: "Current Inventory", objects: products)
                        self.dashboardSectionArray.append(currentInventory)
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getProducts.resume()
    }
    
    // MARK -> Fetching New Data From Server
    func fetchNewDataFromServer (){
        let url = URL(string: urlHost + "products")
        let incomingShipmentsURL = URL(string: urlHost + "orders/notReceived")
        let session = URLSession.shared
        let getPendingOrders = session.dataTask(with: incomingShipmentsURL!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var orders = [NSDictionary]()
                    for shipment in jsonResult {
                        let shipDict = shipment as! NSDictionary
                        orders.append(shipDict)
                    }
                    DispatchQueue.main.async {
                        var incomingShipment: DashboardSection
                        for section in self.dashboardSectionArray {
                            if section.heading == "Incoming Shipments" {
                                incomingShipment = section
                                incomingShipment.items = orders
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getPendingOrders.resume()
        let getProducts = session.dataTask(with: url!, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    var products = [String]()
                    for product in jsonResult {
                        let productDict = product as! NSDictionary
                        products.append(productDict.value(forKey: "name") as! String)
                    }
                    DispatchQueue.main.async {
                        var currentInventorySection: DashboardSection
                        for section in self.dashboardSectionArray {
                            if section.heading == "Current Inventory" {
                                currentInventorySection = section
                                currentInventorySection.items = products
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
            
        })
        getProducts.resume()
    }
    
    // MARK -> Pull to Refresh Function
    //lazy var refreshControl: UIRefreshControl = {
    //    let refreshControl = UIRefreshControl()
    //    refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    //    return refreshControl
    //}()
    
    // MARK -> Handle Refresh and Invoke Fetch New Data Method
    


}
