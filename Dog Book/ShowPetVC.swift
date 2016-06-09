//
//  ShowPetVC.swift
//  Dog Book
//
//  Created by Pongpanot Chuaysakun on 8/29/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class ShowPetVC: UIViewController {
    var pet = PFObject(className: "findFriend")
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeBT: UIButton!
    @IBOutlet weak var followUser: UIButton!
    @IBOutlet weak var nameAgeFollow: UILabel!
    @IBOutlet weak var breedGenderWeight: UILabel!
    
    
    var ownerID:String!
    var userId:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        var query = PFQuery(className: "LikedFriend")
        query.whereKey("userId", equalTo: userId)
        query.whereKey("FriendId", equalTo: pet.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                    self.likeBT.enabled = false
                    self.likeBT.setImage(UIImage(named: "heart-liked"), forState: UIControlState.Normal)
                    
                }
            }
        }
        query = PFQuery(className: "pet")
        query.whereKey("objectId" , equalTo: self.pet["petId"])
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                   let pet = pets?.first
                    self.nameAgeFollow.text = "   "+(pet!["name"] as! String)+", "+String(NSDate().monthsFrom(pet!["birthday"] as! NSDate))+" months"
                    self.breedGenderWeight.text = "Breed : "+(pet!["breed"] as! String)+"  Gender : "+(pet!["gender"] as! String)+"  Weight : " + String(pet!["weight"]!)
                   self.ownerID = pet!["ownerID"]! as! String
                    let qq = PFQuery(className: "follower")
                    qq.whereKey("followerID", equalTo: self.userId)
                    qq.whereKey("userID", equalTo: self.ownerID)
                    qq.findObjectsInBackgroundWithBlock {
                        (pets: [PFObject]?, error: NSError?) -> Void in
                        if error == nil{
                            if pets?.count != 0 {
                                self.followUser.enabled = false
                                self.followUser.setImage(UIImage(named: "follow"), forState: UIControlState.Normal)
                            }
                        }
                    }
                    
                }
            }
        }
        let petImageFile = pet["image"] as! PFFile
        petImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.imageView.image = UIImage(data:imageData)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func likePet(sender: AnyObject) {
        likeBT.setImage(UIImage(named: "heart-liked"), forState: UIControlState.Normal)
        likeBT.enabled = false
        let friend = PFObject(className: "LikedFriend")
        friend["FriendId"] = pet.objectId
        friend["userId"] = userId
        friend.saveInBackground()
    }

    @IBAction func folowUser(sender: AnyObject) {
        self.followUser.enabled = false
        self.followUser.setImage(UIImage(named: "follow"), forState: UIControlState.Normal)
        //if (ownerID != userId){
            let pet = PFObject(className: "follower")
            pet["followerID"] = userId
            pet["userID"] = ownerID
            pet.saveInBackground()
        //}
    }
}
