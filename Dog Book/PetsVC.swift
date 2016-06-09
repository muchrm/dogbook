//
//  PetsVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
import Parse
class PetsVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var petsArrayReceived:[PFObject] = []
    var petAmountReceived:Int = 0
    
    var petSelectedIndex:Int = 0
    
    @IBOutlet var petTable: UITableView!
    @IBOutlet var cellImage: UIImageView!
    // Var for cell
    @IBOutlet var cellName: UILabel!
    @IBOutlet var cellGender: UILabel!
    @IBOutlet var cellColor: UILabel!
    
    var storedId:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //-----------------
        // Set no underline for Table View
        self.petTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
    }

    override func viewDidAppear(animated: Bool) {
         getPetAndUpdateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newPetTapped(sender: UIButton) {
        // go to new pet view
        // Connect already by Segue
    }
  
    // overide
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToPetProfile") {
            let petProfile = segue.destinationViewController as! PetProfileVC;
            // Pass selected pet profile to petProfileReceived at PetProfile
            petProfile.petProfileReceived = self.petsArrayReceived[self.petSelectedIndex]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.petAmountReceived == 0 {
            return 1
        }else{
            return self.petAmountReceived
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("petCell", forIndexPath: indexPath) as? CustomMyPetCell
        if petAmountReceived != 0 {
            cell?.petName!.text = self.petsArrayReceived[indexPath.row]["name"] as? String
            
            let dateFormat = NSDateFormatter();
            dateFormat.dateFormat = "d-MMM-yyyy"
            let birthday = dateFormat.stringFromDate(self.petsArrayReceived[indexPath.row]["birthday"] as! NSDate)
            
            cell?.petBitthday!.text = birthday
            
            // Add pet image here
            cell?.petImage?.image = UIImage(named: "dog2") /* Set default pet image */
            
            if self.petsArrayReceived[indexPath.row]["image"] != nil {
                let userImageFile = self.petsArrayReceived[indexPath.row]["image"] as! PFFile
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            // Found image
                            cell?.petImage?.image = UIImage(data:imageData)
                        }else{
                            // No image, Do notting
                        }
                    }
                }
            }
            
        }else{
            // You don't have pet yet
            cell?.petName.text = "You don't have pet yet"
            cell?.petImage = nil
            cell?.petBitthday.text = ""
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.petSelectedIndex = indexPath.row
        self.performSegueWithIdentifier("goToPetProfile", sender:self)
    }
    
    // This func will update pet table
    func getPetAndUpdateTable(){

        let query = PFQuery(className: "pet")
        query.whereKey("ownerID", equalTo: self.storedId!)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil && pets?.count != 0{
                if let pets = pets as [PFObject]! {
                    // Update new pet array, Clear old pet data in array before !!
                    self.petsArrayReceived = []
                    for pet in pets {
                        self.petsArrayReceived.append(pet)
                    }
                    self.petTable.reloadData()
                }
            }
        }
        
    }
    

}
