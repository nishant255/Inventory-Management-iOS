//
//  File.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/30/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import Foundation

protocol AddNewCompanyDelegate: class {
    
    func saveButtonPressed(controller: AddNewCompanyViewController, newCompany: NSDictionary)
    
    func cancelButtonPressed(controller: AddNewCompanyViewController)
}
