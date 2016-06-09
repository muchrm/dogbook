//
//  PetProfileVC.swift
//  Dog Book
//
//  Created by MEITOEY on 9/3/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class PetProfileVC: UIViewController {

    var petProfileReceived:PFObject!

    @IBOutlet var petNameHeaderLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var petIdLabel: UILabel!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var petWeightLabel: UILabel!
    @IBOutlet var petColorLabel: UILabel!
    @IBOutlet var petBirthdayLabel: UILabel!
    @IBOutlet var petGenderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func updateLayout(){
        // Update image
        // Set default image 
        self.profileImageView.image = UIImage(named: "dog2")
        if self.petProfileReceived["image"] != nil {
            let userImageFile = self.petProfileReceived["image"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        // Found image
                        self.profileImageView.image = UIImage(data:imageData)
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
        
        // Update text layout
        // Header of view
        self.petNameHeaderLabel.text = self.petProfileReceived["name"] as? String
        // Content in view
        self.petNameLabel.text = self.petProfileReceived["name"] as? String
        self.petGenderLabel.text = self.petProfileReceived["gender"] as? String
        self.petColorLabel.text = self.petProfileReceived["color"] as? String
        let weight = self.petProfileReceived["weight"]
        self.petWeightLabel.text = "\(weight)"
        self.petBirthdayLabel.text = birthday

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToPetSetting") {
            let profilesetting = segue.destinationViewController as! PetSettingVC
            profilesetting.petProfileReceived = self.petProfileReceived
        }
        
    }

}
