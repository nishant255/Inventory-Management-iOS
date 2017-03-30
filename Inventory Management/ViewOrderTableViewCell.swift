//
//  ViewOrderTableViewCell.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/29/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class ViewOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var sName: UITextField!
    @IBOutlet weak var sStreet: UITextField!
    @IBOutlet weak var sCity: UITextField!
    @IBOutlet weak var sState: UITextField!
    @IBOutlet weak var sZipCode: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
