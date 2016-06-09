//
//  DisplayNoteVC.swift
//  Dog Book
//
//  Created by fangchanok on 8/31/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class DisplayNoteVC: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myText: UITextView!
    @IBOutlet weak var myTitle: UILabel!
    
    var notePet = PFObject(className: "note")
    override func viewDidLoad() {
        super.viewDidLoad()
        myTitle.text = notePet["name"] as? String
        myText.text = notePet["details"] as? String
        let petImageFile = notePet["image"] as! PFFile
        petImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.myImage.image = UIImage(data:imageData)
                }
            }
        }
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
