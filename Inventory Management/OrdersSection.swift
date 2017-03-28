//
//  OrdersSection.swift
//  Inventory Management
//
//  Created by Marcus Sakoda on 3/28/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

struct OrdersSection {
    var heading: String
    var items: [Any]
    
    init(title: String, objects: [Any]) {
        heading = title
        items = objects
    }
    
}
