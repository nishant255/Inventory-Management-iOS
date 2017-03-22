//
//  CompaniesViewController.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class CompaniesViewController: UIViewController, BackButtonDelegate {
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companiesTableView.dataSource = self
        companiesTableView.delegate = self
        print("companiesviewcontroller loaded")
    }
    @IBOutlet weak var companiesTableView: UITableView!

    var companies = [["Tropicana","Tropicana@OJ.com","(555-555-5555)","123 Tropicana lane, Tropicana City TR, 98765"]]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! CompanyViewController
        controller.backDelegate = self
    }
    
    func backButtonPressed(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CompaniesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        print("this is running")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell")! as! CompaniesCustomCell
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.companyNameLabel.text = companies[indexPath.row][0]
        cell.emailLabel.text = companies[indexPath.row][1]
        cell.phoneLabel.text = companies[indexPath.row][2]
        cell.addressLabel.text = companies[indexPath.row][3]
        // return cell so that Table View knows what to draw in each row
        return cell
    }

}
