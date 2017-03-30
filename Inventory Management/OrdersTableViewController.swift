//
//  OrdersViewController.swift
//  Inventory Management
//
//  Created by Akash Jagannathan on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit



class OrdersTableViewController: UITableViewController, AddOrderDelegate, BackButtonDelegate {
    
    
    //=================================================================
    //                   VARIABLES AND OUTLETS
    //=================================================================
    
    let OM = OrderModel()
    var OrdersSectionArray = [OrdersSection]()
    var orders = [NSDictionary]()
    let LM = LoginRegistrationModel()
    
    //=================================================================
    //                      VIEW DID LOAD
    //=================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrdersTableViewController loaded")
//        OM.getPendingOrders { (ordersFromServer) in
//            self.orders = ordersFromServer
//            self.tableView.reloadData()
//        }
//        refreshControlMethod()
        refreshControl?.addTarget(self, action: #selector(self.refreshControlMethod), for: .valueChanged)
//        tableView.ad
//        tableView.addSubview(refreshControl!)
        fetchDataFromServer()
        
    }
    
    //=================================================================
    //                    FETCH DATA FROM SERVER
    //=================================================================
    
    func fetchDataFromServer() {
        OM.getPendingOrders { (orders) in
            print("orders count: ",orders.count)
            let pendingOrdersSection = OrdersSection(title: "Pending Orders", objects: orders)
            
            //this sets the order of the sections so that Pending orders is always on top
            if self.OrdersSectionArray.count == 0 {
                print("top one is executing")
                self.OrdersSectionArray.append(pendingOrdersSection)
            } else {
                print("bottom one is executing")
                self.OrdersSectionArray.append(pendingOrdersSection)
                let temp = self.OrdersSectionArray[0]
                self.OrdersSectionArray[0] = self.OrdersSectionArray[1]
                self.OrdersSectionArray[1] = temp
            }
            self.tableView.reloadData()
        }
        OM.getReceivedOrders { (orders) in
            let pendingOrdersSection = OrdersSection(title: "Received Orders", objects: orders)
            
            self.OrdersSectionArray.append(pendingOrdersSection)
            self.tableView.reloadData()
        }

    }
    
    func cancelButtonPressed(controller: SelectCompanyTableViewController) {
        dismiss(animated: true, completion: nil)
    }

    
    //=================================================================
    //                    CREATING SECTIONS
    //=================================================================
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return OrdersSectionArray.count
    }
    
    // MARK -> Title for Each Section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return OrdersSectionArray[section].heading
    }
    
    //=================================================================
    //                    CREATING ROWS
    //=================================================================
    
    // MARK -> Number of Rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OrdersSectionArray[section].heading == "Pending Orders" {
            if OrdersSectionArray[section].items.count == 0 {
                return 1
            }
        }
        return OrdersSectionArray[section].items.count
    }
    
    //=================================================================
    //                    CREATING CELLS
    //=================================================================
    
    // MARK -> Data for Each Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK -> If No Incoming Shipments
        
        if OrdersSectionArray[indexPath.section].heading == "Pending Orders" {
            if OrdersSectionArray[indexPath.section].items.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noIncomingShipmentCell", for: indexPath)
                return cell
            }
        }
        
        // MARK -> Data for Incoming Shipments Cell
        
        if OrdersSectionArray[indexPath.section].items[indexPath.row] is NSDictionary {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingShipmentCell", for: indexPath)
            let order = OrdersSectionArray[indexPath.section].items[indexPath.row] as! NSDictionary
            let recipient = order.value(forKey: "recipient") as! NSDictionary
            let email = recipient["email"] as! String
            cell.textLabel?.text = email
//            let data_recipient = reciepient.value(forKey: "data") as! NSDictionary
            let dateString = String(describing: (order).value(forKey: "createdAt")!)
            let dateFormatter = DateFormatter()
            let splitDate = dateString.components(separatedBy: "T")
            if splitDate.count > 0 {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let orderDate = dateFormatter.date(from: splitDate[0])
                cell.detailTextLabel?.text = dateFormatter.string(from: orderDate!)
            }
            return cell
        }

        // MARK -> if None of the Condition Pass
        let cell = tableView.dequeueReusableCell(withIdentifier: "noIncomingShipmentCell", for: indexPath)
        return cell
    }
    
    func refreshControlMethod() {
        OrdersSectionArray = [OrdersSection]()
        fetchDataFromServer()
        refreshControl?.endRefreshing()
        
    }
    
    
    
    // MARK -> Selection Each Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK -> Actionsheet for Recieving Order
        if OrdersSectionArray[indexPath.section].heading == "Pending Orders" {
            if OrdersSectionArray[indexPath.section].items.count > 0 {
                let alertController = UIAlertController(title: "Order Recieved?", message: nil, preferredStyle: .actionSheet)
                let recievedAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { action in
                    print("Recieved Action Clicked")
                    let incomingShipmentSection = self.OrdersSectionArray[indexPath.section]
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
    //                    BACK BUTTON
    //=================================================================

    
    func backButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //=================================================================
    //                    ACCESSORY BUTTON TAPPED
    //=================================================================
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("going to try to segue ViewOrder")
        performSegue(withIdentifier: "ViewOrder", sender: indexPath)
    }
    
    //=================================================================
    //                              SEGUE
    //=================================================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            print("segue identifier is :", id)
        }
        if segue.identifier == "ViewOrder" {
            let indexPath = sender as! IndexPath
            print("clicked section: \(indexPath.section), row: \(indexPath.row)")
            
            let order = OrdersSectionArray[indexPath.section].items[indexPath.row] as! NSDictionary
            print("order is: ",order)
            let recipient = order["recipient"] as! NSDictionary
            let receiverName = "\(String(describing: recipient["first_name"]!)) \(String(describing: recipient["last_name"]!))"
            let orderNumber = order["_id"] as! String
            let orderSender = order["sender"] as! NSDictionary
            let company = orderSender["name"] as! String
            let placedOn = order["createdAt"] as! String
            let receivedOn = order["updatedAt"] as! String
            let products = order["products"] as! [NSDictionary]
            
            let controller = segue.destination as! OrderViewController
            controller.order = order
            controller.orderNumber = orderNumber
            controller.company = company
            controller.placedOn = placedOn
            controller.receivedOn = receivedOn
            controller.products = products
            controller.placedBy = receiverName
            controller.backDelegate = self
        }
        
        
        if segue.identifier == "addNewOrderSegueFromOrders" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! SelectCompanyTableViewController
            controller.delegate = self
        }
        
    }
    
    //=================================================================
    //                           SIGN OUT
    //=================================================================

    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        if LM.signOut(){
            print("Logged Out")
            performSegue(withIdentifier: "signOutSegue", sender: sender)
        }
        
        
    }
    
    
}
