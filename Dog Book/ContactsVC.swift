//
//  ContactsVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
import Parse
class ContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var storedId:String!
    var listOfFollowerImage:[UIImage] = []
    var listOfContract:[PFObject] = []
    var index: Int!
    
    @IBOutlet var msgButton: UIButton!
    @IBOutlet weak var contractTable: UITableView!
    
    override func viewDidLoad() {
        print("viewDidLoad@ContactsVC")
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        // Get coontract list
        getMyContract(id: self.storedId)

    }
    
    override func viewDidAppear(animated: Bool) {

    }

    @IBAction func searchTapped(sender: UIButton) {
        
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToMessageCreate"){
            let message = segue.destinationViewController as! MessageVC
            message.contract = listOfContract[index]
        }
    }
    
    func reloadTable(){
        self.contractTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFollowerImage.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)  as! ContractCell
        cell.profileImage.image = self.listOfFollowerImage[indexPath.row]
        cell.name.text = self.listOfContract[indexPath.row]["name"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.index = indexPath.row
        performSegueWithIdentifier("goToMessageCreate", sender: nil)
    }
    
    func getMyContract(id id: String){
        
        let query = PFQuery(className:"follower")
        query.whereKey("userID", equalTo:id)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                
                // Clear local variable
                self.listOfFollowerImage = []
                
                if let objects = objects! as [PFObject]! {
                    for object in objects {
                        // Get Name and get name
                        self.getConntractNameFromId(id: object["followerID"] as! String)
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
//    func getImageToImageContractList(){
//        // Clear older data 
//        self.listOfFollowerImage = []
//        for contract in self.ListOfContract{
//            self.listOfFollowerImage.append(getImageFromPFFile(file_as_PFFile: contract["image"] as! PFFile))
//        }
//    }
    
    func getConntractNameFromId(id id:String){
        
        let query = PFQuery(className:"user")
        query.whereKey("objectId", equalTo:id)
        query.getFirstObjectInBackgroundWithBlock {
            (object, error: NSError?) -> Void in
            
            if error == nil {
                self.listOfContract.append(object!)
                if object!["image"] != nil {
                    // Have image
                    self.getImageFromPFFile(file_as_PFFile: object!["image"] as! PFFile)
                }else{
                    // Dont have image
                    // Set default image in case user not set image
                    self.listOfFollowerImage.append(UIImage(named: "profile_image")!)
                    self.reloadTable()

                }
                
            }else{
                print("Error: \(error!) \(error!.userInfo)")
            }

        }
    }
    
    func getImageFromPFFile(file_as_PFFile file:PFFile){
        // Set default image in case user not set image
        var image:UIImage = UIImage(named: "profile_image")!
        
        let data = file as PFFile
        data.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    image = UIImage(data:imageData)!
                    self.listOfFollowerImage.append(image)
                    self.reloadTable()
                }
            }
        }
    }

}
