//
//  OrderDetailsTableViewCell.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/28/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productsBuyPrice: UITextField!
    @IBOutlet weak var productQuantity: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
