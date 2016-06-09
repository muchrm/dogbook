//
//  LoginVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UITextFieldDelegate  {
    var userID:String!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate textfield 
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
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
    
    func validation(email email: String, password: String){
        
        let query = PFQuery(className: "user")
        query.whereKey("email", equalTo: email)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
                self.txtError.text = "Incorect Email or Password!, Try again."
                
            } else {
                // The find succeeded.
                print("Debug | validation@LoginVC | Email Found")
                let servPass = object!.objectForKey("password") as! String!
                
                if (servPass == password){
                    print("Debug | validation@LoginVC | Password Correct")
                    let name = object!.objectForKey("name") as! String!
                    print("Debug | validation@LoginVC | id:\(object!.objectId as String!) name:\(name) ")

                    // save to internal memory
                    NSUserDefaults.standardUserDefaults().setObject(object!.objectId as String!, forKey: "userId")
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "session")
                    NSUserDefaults.standardUserDefaults().synchronize();
                    // dismis login view
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }else{
                    print("Debug | validation@LoginVC | Password Incorrect")
                    self.txtError.text = "Incorect Email or Password!, Try again."
                }
                
            }
            
        }

    }
    
    @IBAction func loginTapped(sender: UIButton) {
        
        let email = txtEmail.text as String!
        let password = txtPassword.text as String!
        
        if email != "" && password != "" {
            let md5 = MD5()
            validation(email: email, password: md5.stringToMD5(string: password))
        }else{
            self.txtError.text = "Please Fill Email and Password!"
        }

    }
    
}
