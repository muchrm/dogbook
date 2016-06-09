//
//  EditNoteViewController.swift
//  Dog Book
//
//  Created by fangchanok on 9/1/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class EditNoteViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatePickerDelegate {
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var myDetail: UITextView!
    
    var notePet = PFObject(className: "note")
    var noteDate:String = ""
    var Date = NSDate()
    let DateFormat = NSDateFormatter()
    var idPet:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        DateFormat.dateFormat = "yyyy-MM-dd 11:11:11 +0000"
        Date = DateFormat.dateFromString(noteDate)!
        print(Date)
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(Date)
        
        DateFormat.dateFormat = "yyyy-MM-dd"
        noteDate = DateFormat.stringFromDate(Date)
        
        myDetail.layer.borderWidth = 1
        myDetail.layer.cornerRadius = 5
        myDetail.layer.borderColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0).CGColor
        
        myTitle.text = notePet["name"] as? String
        myDetail.text = notePet["details"] as? String
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
    
    func didSelectValue(value: NSDate) {
        Date = value
        
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(value)
        
        DateFormat.dateFormat = "yyyy-MM-dd"
        noteDate = DateFormat.stringFromDate(value)
        print("Send: \(value) ---- \(noteDate)")
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SendData(sender: AnyObject) {
        let pet = PFObject(className: "note")
        pet["name"] = myTitle.text!
        pet["details"] = myDetail.text!
        pet["petid"] = idPet as String
        let dImage = UIImagePNGRepresentation((myImage.image?.resize(0.2))!);
        pet["image"] = PFFile(name:"image.jpg",data:dImage!)
        pet.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if(success == true) {
                print("UploadComplete: \(pet.objectId!)")
            self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error)
            }
        })
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            myImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            self.dismissViewControllerAnimated(true, completion: nil)
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
