//
//  SearchVC.swift
//  Dog Book
//
//  Created by MEITOEY on 8/31/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class SearchVC: UIViewController {
    
    var found: Bool!
    
    @IBOutlet var notFoundLabel: UILabel!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameText: UILabel!
    @IBOutlet var followText: UIButton!
    
    var idFound:String! = ""
    let storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
    var isFollow:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // hidden search result
        self.profileImage.hidden = true
        self.usernameText.hidden = true
        self.followText.hidden = true
        self.notFoundLabel.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //
    }
    
    func doFollowing(id id:String){
        
        let query = PFObject(className:"follower")
        query["userID"] = id
        query["followerID"] = self.storedId
        
        query.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("You are Following id:\(id) now")
                self.followText.setTitle("Unfollow", forState: .Normal)
                self.isFollow = true
            } else {
                // There was a problem, check error.description
                print("ERROR!!: \(error?.userInfo)" )
            }
        }
        
    }
    
    func doUnfollow(id id: String){
        
        let followerID = self.storedId!
        let userID = id
        let str = "followerID == '\(followerID)' AND userID == '\(userID)'"
        print("Query code: \(str)")
        let predicate = NSPredicate(format: str)
        let query = PFQuery(className: "follower", predicate: predicate)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                object.deleteEventually()
            }
            // Unfollow conplete 
            self.followText.setTitle("Follow", forState: .Normal)
            self.isFollow = false
        }
    }
    
    func searchByEmail(email email:String){

        let query = PFQuery(className: "user")
        query.whereKey("email", equalTo: email)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            
            if error != nil || object == nil  || object == []{
                print("Not found:\(error?.userInfo)")
                self.found = false
                self.notFoundLabel.hidden = false
                self.notFoundLabel.text = "Not found!"
            } else {
                
                self.notFoundLabel.hidden = true
                
                // Save found ID
                self.idFound = object?.objectId
                self.found = true
                
                // LOAD Name                 
                self.usernameText.hidden = false
                self.usernameText.text = object?["name"] as? String
                
                
                // LOAD IMAGE 
                if object?["image"] != nil {
                    let userImageFile = object!["image"] as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.profileImage.image = UIImage(data:imageData)
                                self.profileImage.hidden = false
                            }
                        }
                    }
                }else{
                   // User dont have image 
                    self.profileImage.image = UIImage(named: "profile-icon")
                    self.profileImage.hidden = false
                }
                
                // Check Is me following ? 
                self.isMeFollow(id: self.idFound )
                
                
            }// End of found email
        }
    }
    
    func isMeFollow(id id:String){
        print("****** \(self.storedId):\(idFound):\(id)")
        
        let followerID = self.storedId!
        let userID = id
        let str = "followerID == '\(followerID)' AND userID == '\(userID)'"
        print("Query code: \(str)")
        let predicate = NSPredicate(format: str)
        
        let query = PFQuery(className: "follower", predicate: predicate)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            
            if error != nil || object == nil {
                // not found object
                print("Not follow yet ERR:\(error?.userInfo)")
                // Not follow yet
                // Show button
                self.isFollow = false
                self.followText.setTitle("Follow", forState: .Normal)
                self.followText.hidden = false

            } else {
                // found object
                // Follower already
                print("Follower already Object:\(object)")
                self.isFollow = true
                self.followText.setTitle("Unfollower", forState: .Normal)
                self.followText.hidden = false
                
            }
        }
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchTapped(sender: UIButton) {
        let email = self.emailText.text
        
        if email != nil && email != "" {
            self.emailText.text = ""
            searchByEmail(email: email!)
            
        }

    }
    
    @IBAction func followTapped(sender: UIButton) {
        
        if self.isFollow == true {
           doUnfollow(id: self.idFound)
        }else{
            doFollowing(id: self.idFound)
        }
        
    }

}
