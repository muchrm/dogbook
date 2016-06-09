//
//  RegisterVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
import Parse
class RegisterVC: UIViewController, UITextFieldDelegate  {

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfermPassword: UITextField!
    @IBOutlet var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate textfield 
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.txtConfermPassword.delegate = self
        self.txtName.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // Hide key board
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerTapped(sender: UIButton) {
        
        // do register here 
        // debug
        print(txtEmail.text)
        print(txtPassword.text)
        print(txtConfermPassword.text)
        print(txtName.text)
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        let confermPassword = txtConfermPassword.text!
        let name = txtName.text!
        
        if email.isEmpty || password.isEmpty || confermPassword.isEmpty || name.isEmpty {
            // there is some text field is empty
            // alert
            displayAlertMessage("All field is request")
            return;
        }else if password != confermPassword {
            // password not match 
            // alert
            displayAlertMessage("Password is not match")
            return;
        }else{
            // everything perfect !
            if isEmailAlready(emai: email) {
                // Email is already
            }else{
                registation(eamil: email, password: password, name: name)
                
                // alert complete registation
                let mAlert = UIAlertController(title: "Complete", message: "Registation is succesful. Thank you!", preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                    action in self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                mAlert.addAction(okAction)
                self.presentViewController(mAlert, animated:true, completion:nil);
            }
           }
        
    }
    
    func registation(eamil email:String, password:String, name:String){
        let md5 = MD5()
        let user = PFObject(className:"user")
        user["email"] = email
        user["password"] = md5.stringToMD5(string: password)
        user["name"] = name
        user.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Debug | registation@RegisterVC | Registed")
            } else {
                // There was a problem, check error.description
                print("Debug | registation@RegisterVC | Registation Fail:\(error?.description)")
            }
        }
        
    }
    
    func isEmailAlready(emai email:String)->Bool{
        var result:Bool = false
        
        let query = PFQuery(className: "user")
        query.whereKey("email", equalTo: email)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("Debug | isEmailAlready@RegisterVC | Email not found")
            } else {
                print("Debug | isEmailAlready@RegisterVC | Email is already")
                result = true
            }
        }
        return result
    }
    
    func displayAlertMessage(message : String ){
        let mAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        mAlert.addAction(okAction)
        
        self.presentViewController(mAlert, animated:true, completion:nil);
    }
}
