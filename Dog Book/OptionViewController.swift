//
//  OptionViewController.swift
//  AroundMe
//
//  Created by Pongpanot Chuaysakun on 7/16/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

import UIKit


class OptionViewController: UIViewController {
    var type:[String]!
    var delegate: ChangeMapTypeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        type = ["park","pet_store","veterinary_care"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func changeMapType(sender: UISegmentedControl!) {
       // var view = presentingViewController as? AroundMe!
       // AroundMe.changeMap(type[sender.selectedSegmentIndex])
        delegate?.didSelectValue(type[sender.selectedSegmentIndex])
    //NSNotificationCenter.defaultCenter().postNotificationName("changeMap", object: type[sender.selectedSegmentIndex])
        
    }
    @IBAction func dismiss(gesture: UIGestureRecognizer) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
