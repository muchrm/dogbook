//
//  EditCuresVC.swift
//  Dog Book
//
//  Created by fangchanok on 9/7/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class EditCuresVC: UIViewController, DatePickerDelegate {
    
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var myDetail: UITextView!
    
    var curePet = PFObject(className: "cure")
    var curesDate:String = ""
    var Date = NSDate()
    let DateFormat = NSDateFormatter()
    var idPet:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        DateFormat.dateFormat = "yyyy-MM-dd 11:11:11 +0000"
        Date = DateFormat.dateFromString(curesDate)!
        print(Date)
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(Date)
        
        DateFormat.dateFormat = "yyyy-MM-dd"
        curesDate = DateFormat.stringFromDate(Date)
        
        myDetail.layer.borderWidth = 1
        myDetail.layer.cornerRadius = 5
        myDetail.layer.borderColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0).CGColor
        
        myTitle.text = curePet["name"] as? String
        myDetail.text = curePet["details"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectValue(value: NSDate) {
        Date = value
        
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(value)
        
        DateFormat.dateFormat = "yyyy-MM-dd"
        curesDate = DateFormat.stringFromDate(value)
        print("Send: \(value) ---- \(curesDate)")
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func UpdateData(sender: AnyObject) {
        let pet = PFObject(className: "cure")
        pet["name"] = myTitle.text!
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

        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
