//
//  IncomingShipmentSection.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/23/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation


struct DashboardSection {
    var heading: String
    var items: [Any]    
    
    init(title: String, objects: [Any]) {
        heading = title
        items = objects
    }
    
}
