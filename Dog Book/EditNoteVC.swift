//
//  EditNoteVC.swift
//  Dog Book
//
//  Created by fangchanok on 11/11/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class EditNoteVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatePickerDelegate {

    @IBOutlet weak var MyImage: UIImageView!
    @IBOutlet weak var MyTitle: UITextField!
    @IBOutlet weak var MyDate: UITextField!
    @IBOutlet weak var MyDetail: UITextView!
    
    let DateFormat = NSDateFormatter()
    var notePet = PFObject(className: "note")
    var LinkDate:NSDate!
    var idPet:String!
    var idObject:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        idObject = notePet.objectId!
        LinkDate = notePet["date"]! as! NSDate
        DateFormat.dateFormat = "d MMM yyyy"
        let ShowDate = DateFormat.stringFromDate(notePet["date"]! as! NSDate)
        
        MyDetail.layer.borderWidth = 1
        MyDetail.layer.cornerRadius = 5
        MyDetail.layer.borderColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0).CGColor
        
        MyTitle.text = notePet["name"] as? String
        MyDetail.text = notePet["details"] as? String
        MyDate.text = ShowDate
        let petImageFile = notePet["image"] as! PFFile
        petImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.MyImage.image = UIImage(data:imageData)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectValue(value: NSDate) {
        MyDate.text = DateFormat.stringFromDate(value)
    }

    @IBAction func CancelEdit(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func PickerImage(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        MyImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ComfirmEdit(sender: AnyObject) {
        let prefQuery = PFQuery(className: "note")
        //let prefObj = PFObject(className: "note")
        prefQuery.whereKey("objectId", equalTo: notePet.objectId!)
        prefQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                prefQuery.getObjectInBackgroundWithId(self.notePet.objectId!){
                    (prefObj: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        let AddDate = self.DateFormat.dateFromString(self.MyDate.text!)
                        prefObj!["name"] = self.MyTitle.text!
                        prefObj!["details"] = self.MyDetail.text!
                        prefObj!["date"] = AddDate
                        prefObj!["petid"] = self.idPet as String
                        let dImage = UIImagePNGRepresentation((self.MyImage.image?.resize(0.2))!);
                        prefObj!["image"] = PFFile(name:"image.jpg",data:dImage!)
                        prefObj!.saveInBackground()
                        print("Update Complete: \(self.notePet.objectId!)")
                        print("Update Complete: \(prefObj!.objectId!)")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DatePick = segue.destinationViewController as! DateView
        DatePick.delegate = self
        DatePick.date = LinkDate
    }
}
