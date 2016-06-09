//
//  showGrowInfo.swift
//  Dog Book
//
//  Created by Pongpanot Chuaysakun on 9/4/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

class showGrowInfo: UIViewController {
    var growInfo:String!
    @IBOutlet weak var desLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        desLabel.text = growInfo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func demis(sender: AnyObject) {
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

}
