//
//  DateView.swift
//  Development
//
//  Created by fangchanok on 8/29/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class DateView: UIViewController{

    @IBOutlet weak var myDate: UIDatePicker!
    var delegate : DatePickerDelegate?
    var date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDate.maximumDate = date;
        myDate.setDate(date, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmDate(sender: AnyObject) {
        if let Send = self.delegate {
            Send.didSelectValue(myDate.date)
        }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
