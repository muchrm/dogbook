//
//  DeleteNoteViewController.swift
//  Dog Book
//
//  Created by fangchanok on 9/2/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class DeleteNoteViewController: UIViewController {

    var noteID:String = ""
    var cureID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Note ID  : \(noteID)")
        print("Cures ID : \(cureID)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelDelete(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func AcceptDelete(sender: AnyObject) {
        if noteID != "" {
            let query = PFQuery(className: "note")
            query.whereKey("objectId", equalTo: noteID)
            query.findObjectsInBackgroundWithBlock {
                (pets: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    PFObject.deleteAllInBackground(pets)
                }
            }
        } else if cureID != "" {
            let query = PFQuery(className: "cure")
            query.whereKey("objectId", equalTo: cureID)
            query.findObjectsInBackgroundWithBlock {
                (pets: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    PFObject.deleteAllInBackground(pets)
                }
            }
        }
        
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
