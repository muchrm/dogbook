//
//  DisplayCuresVC.swift
//  Dog Book
//
//  Created by fangchanok on 9/7/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class DisplayCuresVC: UIViewController {

    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDetail: UITextView!
    
    var curePet = PFObject(className: "cure")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTitle.text = curePet["name"] as? String
        myDetail.text = curePet["details"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackPage(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
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
