//
//  AddPetVC.swift
//  Matching
//
//  Created by Pongpanot Chuaysakun on 7/18/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class AddPetVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,PetSelectDelegate{

    @IBOutlet weak var myImage: UIImageView!
    var myPet: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func publishData(sender: AnyObject) {
        
        let pet = PFObject(className: "findFriend")
        
        if(myImage.image != nil && myPet != nil){
            let dImage = UIImagePNGRepresentation((myImage.image?.resize(0.5))!);
            pet["image"] = PFFile(name:"image.jpg",data:dImage!)
            pet["petId"] = myPet
            pet.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if(success == true){
                print("UploadComplete: \(pet.objectId!)")
                self.navigationController?.popViewControllerAnimated(false)
            }else{
                print(error)
            }
            })
        }
        }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        
    {
        myImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func didSelectPet(value: String){
        self.myPet = value
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PetSelectVC
        vc.delegate = self
    }

}

