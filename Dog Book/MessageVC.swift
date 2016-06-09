//
//  MessageVC.swift
//  Dog Book
//
//  Created by MEITOEY on 8/30/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
// custom color HEX
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class MessageVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    // new var
    var contract : PFObject!
    var contractName: String!
    var myName: String!
    var storedId: String!
    var messages:[PFObject] = []
    
    @IBOutlet var messageTable: UITableView!
    @IBOutlet var textField: UITextField!
    
    
    @IBOutlet var titleName: UILabel!
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        self.myName = NSUserDefaults.standardUserDefaults().stringForKey("myName")

        updateLayout()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
//      No underline
//      self.messageTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.textField.delegate = self

    }

    override func viewDidAppear(animated: Bool) {
        if self.contract.objectId != nil {
            fetchMessage(from: self.storedId, to: self.contract.objectId!)
            
            // Set interval
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("fetchMessageAuto"), userInfo: nil, repeats: true)
            
        }else{
            print("Contract ID = nil | MessageVC")
        }

    }
    
    func updateLayout(){
        self.titleName.text = self.contract["name"] as? String
    }
    
    func fetchMessageAuto(){
        fetchMessage(from: self.storedId, to: self.contract.objectId!)
    }
    
    func fetchMessage(from from: String, to: String){
        // Using NSPredicate
        let predicate = NSPredicate(format:"fromID == '\(from)' AND toID == '\(to)' OR fromID == '\(to)' AND toID == '\(from)'")
        let query = PFQuery(className: "chat", predicate: predicate)
        query.orderByAscending("createAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages")
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    self.messages = [] /* Clear older message data */
                    for object in objects {
                        self.messages.append(object)
                    }
                    self.reloadTable()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        

    }
    
    @IBAction func sendTapped(sender: UIButton){
    
        if self.textField.text != nil && self.textField.text != "" {
            self.textField.resignFirstResponder()
            let text = self.textField.text
            self.textField.text = ""
            
            // ###########################
            // SEND New message to Parse server HERE!!!!
            let message = PFObject(className:"chat")
            message["fromID"] = self.storedId
            message["toID"] = self.contract.objectId
            message["text"] = text
            message.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("Message saved -> \(message)")
                } else {
                    print("Message saveing Fail -> \(error?.userInfo)")
                }
                self.fetchMessage(from: self.storedId, to: self.contract.objectId!)}
        }else{
           // DO NOTTING
        }
        

    }
    
    // overide
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        // Set text
        cell.textLabel!.text = self.messages[indexPath.row]["text"] as? String
        // Set sender name
        if self.storedId != self.messages[indexPath.row]["fromID"] as? String {
            
            cell.detailTextLabel!.text = self.contract["name"] as? String
            cell.detailTextLabel!.textColor = UIColor(netHex:0x191919)
            
        }else{
            
            cell.detailTextLabel!.text = self.myName
            cell.detailTextLabel!.textColor = UIColor.orangeColor()

        }
        
        cell.textLabel?.textAlignment = NSTextAlignment.Right
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("you are select #\(indexPath.row)!")
    }
    
    func reloadTable(){
        self.messageTable.reloadData()
    }
    
    /* ######################
    *       Auto Keyboard
    * ###################### */
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true;
    }
    
    
    
    /*
    *   BELOW CODE DID NOT USE !!
    */
//    func tableViewScrollToBottom(animated: Bool) {
//        
//        //        let delay = 0.1 * Double(NSEC_PER_SEC)
//        //        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        //
//        //        dispatch_after(time, dispatch_get_main_queue(), {
//        //
//        //            let numberOfSections = self.messageTable.numberOfSections
//        //            let numberOfRows = self.messageTable.numberOfRowsInSection(numberOfSections-1)
//        //
//        //            if numberOfRows > 0 {
//        //                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
//        //                self.messageTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
//        //            }
//        //            
//        //        })
//    }
}
