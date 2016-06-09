//
//  NewStatusVC.swift
//  Dog Book
//
//  Created by MEITOEY on 8/30/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class NewStatusVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    var storedId: String!
    var urlOfImage: String = ""
    
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet var statusText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImage.image = nil
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        self.myActivityIndicator.hidesWhenStopped = true

    }
    
    @IBAction func postTapped(sender: UIButton) {
        if self.contentImage.image != nil{
            if self.statusText.text != nil {
                imageUploadWithText(image: self.contentImage.image!, text: self.statusText.text! as String, userId: self.storedId )
            }else{
                imageUploadWithText(image: self.contentImage.image!, text: "", userId: self.storedId )
            }
        } else if self.statusText.text != nil {
            uploadText(text: self.statusText.text! as String, userId: self.storedId)
        }
    }
    
    @IBAction func libraryTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func backTapped(sender: UIButton) {
        //  TimelineVC().reloadTimelineLayout()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Dismiss image picker view when user picked an Image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.contentImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    
    func uploadText(text text: String, userId: String){
        self.myActivityIndicator.startAnimating()
        
        let post = PFObject(className:"post")
        post["userID"] = userId
        post["text"] = text
        post.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Posted")
                print("################################################################")
                
            } else {
                // There was a problem, check error.description
                print("Post Fail:\(error?.description)")
                print("################################################################")
                
            }
            self.myActivityIndicator.stopAnimating()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imageUploadWithText(image image: UIImage, text: String, userId: String){
        self.myActivityIndicator.startAnimating()
        
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:generateImageName() as String, data:imageData!)
        
        let post = PFObject(className:"post")
        post["userID"] = userId
        post["text"] = text
        post["image"] = imageFile
        post.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Posted")
                print("################################################################")
                
            } else {
                // There was a problem, check error.description
                print("Post Fail:\(error?.description)")
                print("################################################################")
                
            }
            self.myActivityIndicator.stopAnimating()
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    func generateImageName() -> NSString {
        let len = 15
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

}
