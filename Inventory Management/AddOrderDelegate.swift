//
//  AddOrderDelegate.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/30/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

protocol AddOrderDelegate: class {
    func cancelButtonPressed(controller: SelectCompanyTableViewController)
}
