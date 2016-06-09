//
//  ProfileSettingVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
import Parse
class ProfileSettingVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, /* For deteted Text Field did changed */UITextFieldDelegate {
    
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    var storedId: String!
    var originName: String = ""
    var profileImageReceived: UIImage!
    var profileNameReceived: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("# View Life | ProfileSettingVC | viewDidLoad ")
        
        /* For deteted Text Field did changed */
        /* ###########################################################################################################################################   */
        
        self.txtName.delegate = self
        self.txtName.addTarget(self, action: "profileNameDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        /* ###########################################################################################################################################   */
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        myActivityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide key board
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func editImageTapped(sender: AnyObject) {
//        
//        let myPickerController = UIImagePickerController()
//        myPickerController.delegate = self;
//        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        
//        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
//        self.profileImageRecived = info[UIImagePickerControllerOriginalImage] as? UIImage
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        imageUploadRequest()
        
    }

    func imageUploadRequest(){
      
        
    }
    
    func profileNameDidChange(textField: UITextField) {
        //
        
    }
    
    @IBAction func backTapped(sender: AnyObject) {
        // Dismiss This View
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // Check name is change but NOT nil NOT empty
        // If text was changed then update to Parse server
        if self.txtName.text != self.profileNameReceived && self.txtName.text != "" && self.txtName.text != nil { updateName(name: self.txtName.text!) }

    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        
        // alert
        let mAlert = UIAlertController(title: "Alert", message: "Do you want to logout?.", preferredStyle: UIAlertControllerStyle.Alert);
        
        let logoutAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Default){
            action in
            
            /* clear session */
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "session")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userId")
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "justLogout")
            NSUserDefaults.standardUserDefaults().synchronize();
            
            /* go to login view */
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("goToLoginFromLogout", sender: self)
            
        }
        
        let cancleAction = UIAlertAction(title: "Cancal", style: UIAlertActionStyle.Default, handler: nil)
        
        mAlert.addAction(logoutAction)
        mAlert.addAction(cancleAction)
        
        self.presentViewController(mAlert, animated:true, completion:nil);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("# View Life | ProfileSettingVC | viewWillAppear ")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("# View Life | ProfileSettingVC | viewDidAppear ")
        updateLayout()

    }
    
    func updateLayout(){
        self.txtName.text = self.profileNameReceived
        if self.profileImageReceived != nil {
            self.profileImage.image = profileImageReceived
        }
    }
    
    func updateName(name name: String){
       
        let query = PFQuery(className:"user")
        query.getObjectInBackgroundWithId(self.storedId) {
            (user: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let user = user {
                user["name"] = name
                user.saveInBackground()
                print("Debug | updateName@ProfileSetting | Update complete \(name)")
                // Save value in inner memory to tell anoter profileVC that name or profileImage is changed
                // True -> name is canged.
                // False or nil -> name did not change.
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profileNameDidChange")
                // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profileImageDidChange")
                NSUserDefaults.standardUserDefaults().synchronize();
            }else{
                print("Debug | updateName@ProfileSetting | User id:\(self.storedId) is nil")
            }
        }
        
    }
}


