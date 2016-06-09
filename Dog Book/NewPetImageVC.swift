//
//  NewPetImageVC.swift
//  Dog Book
//
//  Created by MEITOEY on 11/18/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class NewPetImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var name: String!
    var gender: String!
    var color: String!
    var weight: String!
    var birthday: NSDate!
    var image: UIImage!
    
    @IBOutlet weak var displayImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Show image picker when this view was showed

    }
    
    func newPet(){
        // Parse server 
        print("Creating new pet.. | NewPetImageVC")
        print("name:\(self.name)")
        print("gender:\(self.gender)")
        print("color:\(self.color)")
        print("weight\(self.weight)")
        print("birthday:\(birthday)")
        
        var imageData = UIImagePNGRepresentation(self.displayImage.image!)
        
        if self.image != nil {
            imageData = UIImagePNGRepresentation(self.image)
        }
        
        let imageFile = PFFile(name:generateImageName() as String, data:imageData!)

        let pet = PFObject(className:"pet")
        pet["name"] = self.name
        pet["gender"] = self.gender
        pet["color"] = self.color
        pet["weight"] = Double(self.weight)
        pet["birthday"] = self.birthday
        pet["ownerID"] = NSUserDefaults.standardUserDefaults().stringForKey("userId")! as String
        pet["image"] = imageFile
        //###########################
        // DEFAULT BREED !!
        //###########################
        pet["breed"] = "Beagle"
        pet.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("New pet upload complete | NewPetImageVC")
                print("################################################################")

            } else {
                // There was a problem, check error.description
                print("New pet upload Fail:\(error?.description)| NewPetImageVC")
                print("################################################################")

            }
        }
    }
    
    
    // This function for random name for name pet image
    func generateImageName() -> NSString {
        
        let len = 12
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Show image picker when library was tapped
    @IBAction func libraryTapped(sender: AnyObject) {
        showImagePicker()
    }
    
    // Show image picker function
    func showImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Dismiss image picker view when user picked an Image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // Passing picked image to self.image and dismiss image picker
        self.image = image
        self.displayImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // Finished button was tapped
    @IBAction func finishTapped(sender: UIButton) {
        // Create new pet by use newPet() function
        newPet()
        performSegueWithIdentifier("returnToProfileVC", sender: nil)

    }

}
