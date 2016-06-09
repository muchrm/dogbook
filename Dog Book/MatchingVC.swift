//
//  ViewController.swift
//  Matching
//
//  Created by Pongpanot Chuaysakun on 7/17/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class MatchingVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,BreedPickerDelegate{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
     let date = NSDate()
    var petList:[PFObject]!
    override func viewDidLoad() {
        self.setNavigationBarItem()
        super.viewDidLoad()
        print(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let query = PFQuery(className: "findFriend")
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                    self.petList = pets
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if petList == nil {
            return 0
        }
        else{
            return self.petList.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MatchingCell
        let petImageFile = petList[indexPath.row].objectForKey("image") as! PFFile
        petImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.profileImage.image = UIImage(data:imageData)
                }
            }
        }
        cell.likeBT.enabled = true
        cell.likeBT.setImage(UIImage(named: "heart-unlike"), forState: UIControlState.Normal)
        var query = PFQuery(className: "LikedFriend")
        query.whereKey("userId", equalTo: NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
        query.whereKey("FriendId", equalTo: petList[indexPath.row].objectId!)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                    cell.likeBT.enabled = false
                    cell.likeBT.setImage(UIImage(named: "heart-liked"), forState: UIControlState.Normal)
                    
                }
            }
        }
        query = PFQuery(className:"pet")
        query.whereKey("objectId", equalTo: petList[indexPath.row].objectForKey("petId")!)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                    let pet = pets?.first
                    cell.nameAgeLiked.text = (pet!["name"] as! String)+", "+String(NSDate().monthsFrom(pet!["birthday"] as! NSDate))+" months";
                }
            }
        }
        return cell
    }
    
    @IBAction func buttonPress(sender: AnyObject) {
        let sw = sender as! UIButton
        let view = sw.superview!
        let view2 = view.superview
        let cell = view2!.superview as! MatchingCell
        cell.likeBT.setImage(UIImage(named: "heart-liked"), forState: UIControlState.Normal)
        cell.likeBT.enabled = false
        let indexCell = tableView.indexPathForCell(cell)!
            print("on")
            let friend = PFObject(className: "LikedFriend")
            friend["FriendId"] = petList[indexCell.row].objectId
            friend["userId"] = NSUserDefaults.standardUserDefaults().stringForKey("userId")!
            friend.saveInBackground()
    }
    
    func didSelectValue(value: String) {
        print(value)
        let query = PFQuery(className: "findFriend")
        if(value != "ALL BREED"){
            query.whereKey("breed", equalTo: value)
        }
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                    self.petList = pets
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BreedSelectShow" {
        let vc = segue.destinationViewController as! BreedPicker
        vc.delegate = self
        }else if segue.identifier == "ShowPet" {
            let vc = segue.destinationViewController as! ShowPetVC
            let pet = petList[tableView.indexPathForSelectedRow!.row]
            vc.pet = pet
        }
    }
}

