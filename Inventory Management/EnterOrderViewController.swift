//
//  EnterOrderViewController.swift
//  Inventory Management
//
//  Created by Nishant Patel on 3/27/17.
//  Copyright © 2017 Nishant Patel. All rights reserved.
//

import UIKit

class EnterOrderViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var saName: UITextField!
    @IBOutlet weak var saStreet: UITextField!
    @IBOutlet weak var saCity: UITextField!
    @IBOutlet weak var saState: UITextField!
    @IBOutlet weak var saZipCode: UITextField!
    
    
    
    var productsSelected = [NSDictionary]()
    //var activeField: UITextField?
    //let scrollView = UIScrollView()
    var frameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.frameView = UIView(frame: CGRect(x: 0,y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        
        // Keyboard stuff.
//        let center: NotificationCenter = NotificationCenter.default
//        center.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        center.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            print("Do Nothing")
        default:
            scrollView.setContentOffset(CGPoint(x:0,y:100), animated: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField.tag == 0
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func viewOrderButtonPressed(_ sender: UIButton) {
    }
    
    func keyboardWillShow(notification: NSNotification) {
//        let info:NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        
//        let keyboardHeight: CGFloat = keyboardSize.height
//        
//        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as! CGFloat
//        
//        
//        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            self.frameView.frame = CGRect(x : 0,y : (self.frameView.frame.origin.y - keyboardHeight),width: self.view.bounds.width,height: self.view.bounds.height)
//        }, completion: nil)
        if (self.view.frame.origin.y >= 0)
        {
            self.setViewMovedUp(movedUp: true)
        }
        else if (self.view.frame.origin.y < 0)
        {
            self.setViewMovedUp(movedUp: false)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        let info: NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        
//        let keyboardHeight: CGFloat = keyboardSize.height
//        
//        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as! CGFloat
//        
//        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            self.frameView.frame = CGRect(x: 0,y: (self.frameView.frame.origin.y + keyboardHeight),width: self.view.bounds.width,height: self.view.bounds.height)
//        }, completion: nil)
        if (self.view.frame.origin.y >= 0)
        {
            self.setViewMovedUp(movedUp: true)
        }
        else if (self.view.frame.origin.y < 0)
        {
            self.setViewMovedUp(movedUp: false)
        }
        

        
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField.isEqual((saName != nil) || (saCity != nil) || (saState != nil) || (saStreet != nil) || (saZipCode != nil)) {
//            if  (self.view.frame.origin.y >= 0)
//            {
//                self.setViewMovedUp(movedUp: true)
//            }
//        }
//    }
//    
    func setViewMovedUp(movedUp: Bool){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        if movedUp {
            rect.origin.y -= 80.0
            rect.size.height += 80.0
        } else {
            rect.origin.y += 80.0
            rect.size.height -= 80.0
        }
        self.view.frame = rect
        
        UIView.commitAnimations()
        
    }
    
    func keyboardUP(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 253
        }
    }
    func keyboardDown(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 0
        }
    }

}

extension EnterOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTableViewCell", for: indexPath) as! OrderDetailsTableViewCell
        let product = productsSelected[indexPath.row]
        cell.productNameLabel.text = product["name"] as? String
        return cell
    }

}

//MARK: - Keyboard Management Methods
/*
extension EnterOrderViewController {
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(EnterOrderViewController.keyboardWillBeShown(sender:)),
                                       name: NSNotification.Name.UIKeyboardWillShow,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(EnterOrderViewController.keyboardWillBeHidden(sender:)),
                                       name: NSNotification.Name.UIKeyboardWillHide,
                                       object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = activeField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!aRect.contains(activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        activeField = textField
        scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        activeField = nil
        scrollView.isScrollEnabled = false
    }
}
 */
