//
//  PetSelectVCViewController.swift
//  Dog Book
//
//  Created by Pongpanot Chuaysakun on 9/2/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class PetSelectVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var mytable: UITableView!
    var pet:[PFObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        var id =  NSUserDefaults.standardUserDefaults().stringForKey("userId")
        if id == nil {
            id = "0"
        }else{
            let query = PFQuery(className: "pet")
            query.whereKey("ownerID", equalTo: id!)
            query.findObjectsInBackgroundWithBlock {
                (pets: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    if pets?.count != 0 {
                        print("Debug | PetSelect | Successfully retrieved \(pets!.count).")
                        self.pet = pets as [PFObject]!
                        self.mytable.reloadData()
                    }else{
                        print("Debug | PetSelect | posts count: \(pets?.count)")
                    }
                }else{
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
          
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pet == nil {
            return 0
        }
        else{
            return self.pet.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mytable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuPetCell
        cell.myLabel.text = pet[indexPath.row].objectForKey("name") as! String!
        cell.myImage.image = UIImage(named: "dog2")
        let petImageFile = pet?[indexPath.row].objectForKey("image") as! PFFile
        petImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.myImage.image = UIImage(data:imageData)
                }
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setValue(pet[indexPath.row].objectId, forKeyPath: "idPet")
        NSUserDefaults.standardUserDefaults().setObject(pet[indexPath.row]["birthday"], forKey: "datePet")
        NSUserDefaults.standardUserDefaults().synchronize();
        NSNotificationCenter.defaultCenter().postNotificationName("setNewPet", object: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
