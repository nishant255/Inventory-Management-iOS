//
//  CompaniesViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class CompaniesTableViewController: UITableViewController {
    
    //=================================================================
    //                     VARIABLES AND OUTLETS
    //=================================================================
    
    let CM = CompanyModel()
    let LM = LoginRegistrationModel()
    var companies = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        CM.getAllCompanies { (companiesFromServer) in
            print("companies is: ",companiesFromServer)
            self.companies = companiesFromServer
            self.tableView.reloadData()
        }
    }

    //=================================================================
    //                     CREATING CELLS
    //=================================================================
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell")
        
        let company = companies[indexPath.row]
        let companyName = company["name"]
        let companyProducts = company["products"] as! NSArray
        
        cell?.textLabel?.text = companyName as! String?
        cell?.detailTextLabel?.text = "Products: \(String(companyProducts.count))"
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCompany", sender: indexPath)
    }
    
    //=================================================================
    //                            SEGUE
    //=================================================================

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCompany" {
            let indexPath = sender as! IndexPath
            let company = companies[indexPath.row]
            
            let controller = segue.destination as! CompanyViewController
            
            controller.company = company
        }
        
    }
    
    //=================================================================
    //                           SIGN OUT
    //=================================================================

    @IBAction func signOutButtonPressed(_ sender: Any) {
        if LM.signOut(){
            print("Logged Out")
            performSegue(withIdentifier: "signOutSegue", sender: sender)
        }

    }

    
}

