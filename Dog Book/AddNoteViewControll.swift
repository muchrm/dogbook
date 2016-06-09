//
//  AddNoteViewControll.swift
//  Development
//
//  Created by fangchanok on 8/27/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class AddNoteViewControll: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatePickerDelegate {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var myAbout: UITextField!
    @IBOutlet weak var myDate: UITextField!
    var Date = NSDate()
    let DateFormat = NSDateFormatter()
    var idPet:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        
        DateFormat.dateFormat = "d MMM yyyy"
        myDate.text = DateFormat.stringFromDate(Date)
        print("\(idPet)")
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
    }
    
    @IBAction func CancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SendData(sender: AnyObject) {
        let AddDate = DateFormat.dateFromString(myDate.text!)
        let pet = PFObject(className: "note")
        pet["name"] = myName.text!
        pet["details"] = myAbout.text!
        pet["date"] = AddDate
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
