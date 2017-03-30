//
//  ProductTableViewCell.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/29/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBuyPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
