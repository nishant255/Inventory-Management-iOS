//
//  UsersCustomCell.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation
import UIKit

class UsersCustomCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var adminButtonLabel: UIButton!
    
    @IBAction func adminButtonPressed(_ sender: Any) {
    }
}
