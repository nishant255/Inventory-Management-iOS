//
//  DashboardViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, AddOrderDelegate, BackButtonDelegate {
    
    // =================================================
    // ALL THE OUTLET AND CONTROLLER VARIABLE
    // =================================================
    
    
    @IBOutlet weak var dashboardTableView: UITableView!
        
    
        
    let DM = DashboardModel()
    let IM = InventoryModel()
    let OM = OrderModel()
    let UM = UserModel()
    let LM = LoginRegistrationModel()
    let CM = CompanyModel()
    
    
    var dashboardSectionArray = [DashboardSection]()
        
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // On View Load and Memeory Warning
    override func viewDidLoad() {
        super.viewDidLoad()
        if !LM.checkLogin() {
            print("Not Logged In")
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        }
        if UM.getCoreDataUser()?.admin == 0 {
            self.title = "Boss Dashboard"
        }else if UM.getCoreDataUser()?.admin == 1 {
            self.title = "Admin Dashboard"
        }
        refreshControl.addTarget(self, action: #selector(DashboardViewController.refreshControlMethod), for: .valueChanged)
        self.dashboardTableView.addSubview(refreshControl)
        fetchDataFromServer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {        
        if LM.signOut(){
            print("Logged Out")
            performSegue(withIdentifier: "signOutSegue", sender: sender)
        }
    }
    
    @IBAction func addNewOrderButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewOrderSegueFromDashboard", sender: sender)
    }
    
    func fetchDataFromServer() {
        OM.getPendingOrders { (orders) in            
            let incomingShipment = DashboardSection(title: "Incoming Shipments", objects: orders)
            if self.dashboardSectionArray.count == 0 {
                self.dashboardSectionArray.append(incomingShipment)
            } else {
                self.dashboardSectionArray.append(incomingShipment)                
                let temp = self.dashboardSectionArray[0]
                self.dashboardSectionArray[0] = self.dashboardSectionArray[1]
                self.dashboardSectionArray[1] = temp
            }
            self.dashboardTableView.reloadData()
        }
        IM.getAllProductsforDashboard { (products) in
            let currentInventory = DashboardSection(title: "Current Inventory", objects: products)
            self.dashboardSectionArray.append(currentInventory)
            self.dashboardTableView.reloadData()
        }
    }
    
    func refreshControlMethod() {
        dashboardSectionArray = [DashboardSection]()
        fetchDataFromServer()
        refreshControl.endRefreshing()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewOrderSegueFromDashboard" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! SelectCompanyTableViewController
            controller.delegate = self
        }
        
        if segue.identifier == "ViewOrder" {
            let indexPath = sender as! IndexPath
            print("clicked section: \(indexPath.section), row: \(indexPath.row)")
            
            let order = dashboardSectionArray[indexPath.section].items[indexPath.row] as! NSDictionary
            print("order is: ",order)
            let recipient = order["recipient"] as! NSDictionary
            let receiverName = "\(String(describing: recipient["first_name"]!)) \(String(describing: recipient["last_name"]!))"
            let orderNumber = order["_id"] as! String
            let orderSender = order["sender"] as! NSDictionary
            let company = orderSender["name"] as! String
            let placedOn = order["createdAt"] as! String
            let receivedOn = order["updatedAt"] as! String
            let products = order["products"] as! [NSDictionary]
            
            let nav = segue.destination as! UINavigationController
            
            let controller = nav.topViewController as! OrderViewController
            controller.order = order
            controller.orderNumber = orderNumber
            controller.company = company
            controller.placedOn = placedOn
            controller.receivedOn = receivedOn
            controller.products = products
            controller.placedBy = receiverName
            controller.backDelegate = self
        }

    }
    
    func cancelButtonPressed(controller: SelectCompanyTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //=================================================================
    //                    BACK BUTTON
    //=================================================================
    
    
    func backButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }

    
    
 
}


    //=================================================================
    //                    TABLEVIEW EXTENSION
    //=================================================================

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK -> Number of Sections in Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return dashboardSectionArray.count
    }
    
    // MARK -> Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if indexPath.section < dashboardSectionArray.count {
            
        
            if dashboardSectionArray[indexPath.section].heading == "Incoming Shipments" {
                if dashboardSectionArray[indexPath.section].items.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noIncomingShipmentCell", for: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                }
            }
            
            // MARK -> Data for Incoming Shipments Cell
            
            if dashboardSectionArray[indexPath.section].items[indexPath.row] is NSDictionary {
                print("there should be some pending orders!")
                print("heading is: ",dashboardSectionArray[indexPath.section].heading)
                let cell = tableView.dequeueReusableCell(withIdentifier: "incomingShipmentCell", for: indexPath) as! IncomingShipmentTableViewCell
                let order = dashboardSectionArray[indexPath.section].items[indexPath.row] as! NSDictionary
                print("order is: ")
                let sender = order.value(forKey: "sender") as! NSDictionary
                print(sender)
                cell.orderTitleLabel.text = sender.value(forKey: "name") as? String
                let dateString = String(describing: (order).value(forKey: "createdAt")!)
                let dateFormatter = DateFormatter()
                let splitDate = dateString.components(separatedBy: "T")
                if splitDate.count > 0 {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let orderDate = dateFormatter.date(from: splitDate[0])
                    cell.orderDateLabel.text = dateFormatter.string(from: orderDate!)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.default
                return cell
            }
            
            // MARK -> Data for Current Inventory Cell
            
            if dashboardSectionArray[indexPath.section].items[indexPath.row] is String {
                let cell = tableView.dequeueReusableCell(withIdentifier: "currentInventoryProductCell", for: indexPath) as! CurrentInventoryTableViewCell
                cell.productLabel.text = dashboardSectionArray[indexPath.section].items[indexPath.row] as? String
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
        }
        
        // MARK -> if None of the Condition Pass
        let cell = tableView.dequeueReusableCell(withIdentifier: "noIncomingShipmentCell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK -> Selection Each Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK -> Actionsheet for Recieving Order
        if dashboardSectionArray[indexPath.section].heading == "Incoming Shipments" {
            if dashboardSectionArray[indexPath.section].items.count > 0 {
                let alertController = UIAlertController(title: "Order Recieved?", message: nil, preferredStyle: .actionSheet)
                let recievedAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { action in
                    print("Recieved Action Clicked")
                    let incomingShipmentSection = self.dashboardSectionArray[indexPath.section]
                    let order = incomingShipmentSection.items[indexPath.row] as! NSDictionary
                    self.OM.recieveOrder(order: order, completionHandler: { (result, message) in
                        if result == true {
                            let alertForOrder = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                                self.refreshControlMethod()
                            }
                            alertForOrder.addAction(OKAction)
                            self.present(alertForOrder, animated: true, completion: nil)
                        } else {
                            let alertForOrder = UIAlertController(title: "Order Error", message: message, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { action in
                                self.refreshControlMethod()
                            }
                            alertForOrder.addAction(OKAction)
                            self.present(alertForOrder, animated: true, completion: nil)
                        }
                    })
                }
                
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { action in
                }
                
                alertController.addAction(recievedAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //=================================================================
    //                    ACCESSORY BUTTON TAPPED
    //=================================================================
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("going to try to segue ViewOrder")
        performSegue(withIdentifier: "ViewOrder", sender: indexPath)
    }

}
