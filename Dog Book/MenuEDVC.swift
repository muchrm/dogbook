//
//  MenuEDVC.swift
//  Dog Book
//
//  Created by fangchanok on 11/18/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class MenuEDVC: UIViewController {
    
    var curePet = PFObject(className: "cure")
    var idCure:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        idCure = curePet.objectId!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Disabled(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func EditorMenu(sender: AnyObject) {
        print("Editor Menu Test!!!")
    }
    
    @IBAction func DeleteMenu(sender: AnyObject) {
        print("Delete Menu Test!!!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditCures" {
            let nextLink = segue.destinationViewController as! EditCuresVC
            nextLink.curePet = curePet
        } else if segue.identifier == "DeleteCures" {
            let nextLink = segue.destinationViewController as! DeleteNoteViewController
            nextLink.cureID = idCure
        }
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
