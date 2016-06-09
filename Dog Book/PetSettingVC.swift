//
//  PetSettingVC.swift
//  Dog Book
//
//  Created by MEITOEY on 9/6/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class PetSettingVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var petProfileReceived:PFObject!
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    // Recived variables
    var petProfileImageRecived: UIImage!
    var petIdRecived: String!
    var petNameRecived: String!
    var petBirthdayRecived: String!
    var petColorRecived: String!
    var petWeightRecived: String!
    var petGenderRecived: String!

    
    @IBOutlet var petProfileImage: UIImageView!
    @IBOutlet var petNameLabel: UITextField!
    @IBOutlet var petGenderLabel: UITextField!
    @IBOutlet var petBirthdayLabel: UITextField!
    @IBOutlet var petColorLabel: UITextField!
    @IBOutlet var petWeightLabel: UITextField!
    
    @IBAction func editImageTapped(sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backTapped(sender: UIButton) {
        // Update to Parse sever
        updatePetProfileToServer()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func updateLayout() {
        // Profile Image
        // Set default image
        self.petProfileImage.image = UIImage(named: "dog2")
        if self.petProfileReceived["image"] != nil {
            let userImageFile = self.petProfileReceived["image"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        // Found image
                        self.petProfileImage.image = UIImage(data:imageData)
                    }else{
                        // No image, Do notting
                    }
                }
            }
        }
        
        
        // Formating birthday
        let dateFormat = NSDateFormatter();
        dateFormat.dateFormat = "d-MMM-yyyy"
        let birthday = dateFormat.stringFromDate(self.petProfileReceived["birthday"] as! NSDate)
        
        // self.petProfileImage.image
        self.petNameLabel.text = self.petProfileReceived["name"] as? String
        self.petGenderLabel.text = self.petProfileReceived["gender"] as? String
        self.petBirthdayLabel.text = birthday
        self.petColorLabel.text = self.petProfileReceived["color"] as? String
        self.petWeightLabel.text = self.petProfileReceived["weight"] as? String
        
    }
    
    func updatePetProfileToServer(){
        // Update pet profile to Parse server
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        
    {
//        self.petProfileImageRecived = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}
