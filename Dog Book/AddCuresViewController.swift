//
//  AddCuresViewController.swift
//  Development
//
//  Created by fangchanok on 8/30/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class AddCuresViewController: UIViewController, DatePickerDelegate {
    
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var myDetail: UITextField!
    
    var Date = NSDate()
    var Date2:String = "";
    let DateFormat = NSDateFormatter()
    var idPet:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(Date)
        
        DateFormat.dateFormat = "yyyy-MM-dd"
        Date2 = DateFormat.stringFromDate(Date)
        
        print("\(idPet)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Cancel(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSelectValue(value: NSDate) {
        Date = value
        
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(value)
        
        DateFormat.dateFormat = "yyyy-MM-dd"
        Date2 = DateFormat.stringFromDate(value)
    }
    
    @IBAction func UploadData(sender: AnyObject) {
        let pet = PFObject(className: "cure")
        pet["name"] = myName.text!
        pet["details"] = myDetail.text!
        pet["petid"] = idPet as String
        pet.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if(success == true) {
                print("UploadComplete: \(pet.objectId!)")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error)
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DatePick = segue.destinationViewController as! DateView
        DatePick.delegate = self
        
        DatePick.date = Date
    }

}
