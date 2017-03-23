//
//  OrderDetailViewController.swift
//  Inventory Management
//
//  Created by Akash Jagannathan on 3/22/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController{
    
    weak var delegate: OrderDetailViewControllerDelegate?
    
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.orderDetailViewController(by: self, didPressBackButton: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
