//
//  PendingOrdersTableViewCell.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class PendingOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
