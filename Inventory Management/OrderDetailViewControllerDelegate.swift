//
//  OrderDetailViewControllerDelegate.swift
//  Inventory Management
//
//  Created by Akash Jagannathan on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

protocol OrderDetailViewControllerDelegate: class{
    func orderDetailViewController(by controller: OrderDetailViewController, didPressBackButton: UIBarButtonItem)
}
