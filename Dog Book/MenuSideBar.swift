//
//  MenuSideBar.swift
//  Dog Book
//
//  Created by Pongpanot Chuaysakun on 7/26/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
enum LeftMenu: Int {
    case myDog = 0
    case AroundMe
    case SymptomSearch
    case Matching
    case Topic
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class MenuSideBar: UIViewController,LeftMenuProtocol{
    @IBOutlet weak var tableView: UITableView!
    var menus = ["My Dog", "Around Me", "Symptom Search", "Find Friend","Topic"]
    var icons = ["dog2","map","search","dog","topic"]
    var profileViewController: UIViewController!
    var growthViewControler: UIViewController!
    var growthView:UITabBarController!
    var inboxViewController: UIViewController!
    var aroundMeViewController: UIViewController!
    var symptomSearchViewController: UIViewController!
    var matchingViewController: UIViewController!
    var topicViewController: UIViewController!
    var myStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NSUserDefaults.standardUserDefaults().setValue("1", forKeyPath: "idPet")
        NSUserDefaults.standardUserDefaults().synchronize();
        
        
        growthView = myStoryboard.instantiateViewControllerWithIdentifier("tab_grow") as! UITabBarController
        growthView.setNavigationBarItem()
        setRighBar()
        self.growthViewControler = UINavigationController(rootViewController: growthView)
        
        
        let aroundMeViewController = myStoryboard.instantiateViewControllerWithIdentifier("aroundMe") as! AroundMe
        self.aroundMeViewController = UINavigationController(rootViewController: aroundMeViewController)
        
        let symptomSearchViewController = myStoryboard.instantiateViewControllerWithIdentifier("symptomSearch") as! CategoryViewController
        self.symptomSearchViewController = UINavigationController(rootViewController: symptomSearchViewController)
        
        let matchingViewController = myStoryboard.instantiateViewControllerWithIdentifier("matching") as! MatchingVC
        self.matchingViewController = UINavigationController(rootViewController: matchingViewController)
        
        let topicViewController = myStoryboard.instantiateViewControllerWithIdentifier("topic") as! TopicCategoryViewController
        self.topicViewController = UINavigationController(rootViewController: topicViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
    }
    func setRighBar(){
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        //set image for button
        button.setImage(UIImage(named: "dog2"), forState: UIControlState.Normal)
        var id = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        if id == nil {
            id = "0"
        }else{
            let query = PFQuery(className: "pet")
            query.whereKey("ownerID", equalTo: id!)
            query.findObjectsInBackgroundWithBlock {
                (pets: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil{
                    if pets?.count != 0 {
                        print("Debug | MenuSideBar | Successfully retrieved \(pets!.count).")
                        if let pets = pets as [PFObject]! {
                           let pet = pets.first
                            NSUserDefaults.standardUserDefaults().setValue(pet!.objectId, forKeyPath: "idPet")
                            NSUserDefaults.standardUserDefaults().setObject(pet!.objectForKey("birthday"), forKey: "datePet")
                            NSUserDefaults.standardUserDefaults().synchronize();
                            let petImageFile = pet!.objectForKey("image") as! PFFile
                            petImageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        button.setImage(UIImage(data:imageData), forState: UIControlState.Normal)
                                    }
                                }
                            }
                        }
                    }else{
                        print("Debug | MenusideBar | posts count: \(pets?.count)")
                    }
                }else{
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
            button.addTarget(self, action: "callPetSelect", forControlEvents: UIControlEvents.TouchUpInside)
            //set frame
            button.frame = CGRectMake(0, 0, 40, 40)
            
            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            growthView.navigationItem.setRightBarButtonItem(barButton, animated: false)


        }
        
    }
    func callPetSelect(){
        let nextViewController = myStoryboard.instantiateViewControllerWithIdentifier("petSelectVC") as! PetSelectVCViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuCell
        cell.myLabel.text  = menus[indexPath.row]
        cell.myImage.image = UIImage(named:icons[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    @IBAction func goToProfile(sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
    }
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .myDog:
            self.slideMenuController()?.changeMainViewController(self.growthViewControler, close: true)
            break
        case .AroundMe:
            self.slideMenuController()?.changeMainViewController(self.aroundMeViewController, close: true)
            break
        case .SymptomSearch:
            self.slideMenuController()?.changeMainViewController(self.symptomSearchViewController, close: true)
            break
        case .Matching:
            self.slideMenuController()?.changeMainViewController(self.matchingViewController, close: true)
            break
        case .Topic:
            self.slideMenuController()?.changeMainViewController(self.topicViewController, close: true)
            break
        }

    }
    
    
}
