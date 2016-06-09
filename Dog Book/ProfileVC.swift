//
//  ProfileVC.swift
//  Dog Book
//
//  Created by Pongpanot Chuaysakun on 7/26/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postsArray:[PFObject] = []
    var petsArray:[PFObject] = []
    var petAmount: Int = 0
    var postCount: Int = 0
    var follower: Int = 0
    var following: Int = 0
    @IBOutlet var amountOfPetsLabel: UILabel!
    @IBOutlet var amountOfFollowingLabel: UILabel!
    @IBOutlet var amountOfFollower: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var statusTable: UITableView!
    @IBOutlet var txtName: UILabel!
    @IBOutlet var txtEmail: UILabel!
    @IBOutlet var imageProfile: UIImageView!

    var timelineList: NSArray?
    var storedSession:Bool?
    var storedId:String?
    
    override func viewDidLoad() {
        print("# View Life | ProfileVC | viewDidLoad ")
        super.viewDidLoad()

        // Navigation Bar
        self.setNavigationBarItem()
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "setting")! .imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // Set no underline for Table View
        self.statusTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        print("Debug | viewDidLoad@ProfileVC | start")
        authentication()
        
    }
    override func viewWillAppear(animated: Bool) {
        print("# View Life | ProfileVC | viewWillAppear ")

    }
    
    override func viewDidAppear(animated: Bool) {
        print("# View Life | ProfileVC | viewDidAppear ")
        self.storedSession = NSUserDefaults.standardUserDefaults().boolForKey("session")
        if self.storedSession == true {
            // User stil loged in Update id from inner memory
            self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
            
            // Check user just logout and login again ?
            if NSUserDefaults.standardUserDefaults().boolForKey("justLogout") == true {
                // Yes, User just logout and login again may be diference user so let update layout view and profile data
                updateLayout()
                // Update justLogout value from true -> false
                NSUserDefaults.standardUserDefaults().setObject(false, forKey: "justLogout")
                NSUserDefaults.standardUserDefaults().synchronize();
            
            } else{
                // User is still loged in may be change name or image? let checking here !
                // Check name did change? # profileNameDidChange stored Bool true -> name was change !
                // so update name from Parse server here now.
                print("profile name did change : \(NSUserDefaults.standardUserDefaults().boolForKey("profileNameDidChange"))")
                if NSUserDefaults.standardUserDefaults().boolForKey("profileNameDidChange") == true {
                    updateProfile()
                    // Update profileNameDidChange from true -> false
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "profileNameDidChange")
                    NSUserDefaults.standardUserDefaults().synchronize();

                }

            }
            
            // You have to reload post every view refresh then getPost() again to fetch data from Parse server and 
            // reload table when there get some new posts PS. getPost() was code to automatic reload table.
            getPost(fromFunc: "viewDidAppear@ProfileVC")
            
            // Update pet again
            getPet()
            
        }else{
            // Session was expired
            gotoLogin()
        }

    }
    
    func authentication(){
        
        self.storedSession = NSUserDefaults.standardUserDefaults().boolForKey("session")
        
        if self.storedSession == true {
            
            // User is login now and Get update id from inner memory
            self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
            
            // Update layout view
            updateLayout()
            
        }else{
            // Session was expired
            gotoLogin()
        }
    }
    
    func gotoLogin(){
        print("Debug | viewDidLoad@ProfileVC | No login storedSession = \(self.storedSession)")
        self.performSegueWithIdentifier("goToLogin", sender: self)
    }
    
    func updateLayout(){
        // If in user did not set image profile, so let image profile to default
        imageProfile.image = UIImage(named: "profile-icon")! // default
        updateProfileAndImage()
        
        // Reload table data
        self.reloadTable()
    }
    
    func updateProfile(){
        
        // update profile name
        let profile = PFQuery(className: "user")
        profile.whereKey("objectId", equalTo: storedId!)
        profile.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("Debug | updateProfile@ProfileVC | User not found")
            } else {
                print("Debug | updateProfile@ProfileVC | User found")
                self.txtName.text = object!["name"] as? String
                self.txtEmail.text = object!["email"] as? String
                
                NSUserDefaults.standardUserDefaults().setObject(self.txtName.text, forKey: "myName")
                NSUserDefaults.standardUserDefaults().synchronize();
            }
        }
    }

    func updateProfileAndImage(){
        print("Debug | updateProfileAndImage@ProfileVC | start storedId:\(self.storedId!)")

        // update follow amount
        // Update variables value before update layout and code to update layout inside
        getMyFollower()
        getMyFollowing()

        // update profile name
        let profile = PFQuery(className: "user")
        profile.whereKey("objectId", equalTo: storedId!)
        profile.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("Debug | updateProfileAndImage@ProfileVC | User not found")
            } else {
                print("Debug | updateProfileAndImage@ProfileVC | User found")
                self.txtName.text = object!["name"] as? String
                self.txtEmail.text = object!["email"] as? String
                
                NSUserDefaults.standardUserDefaults().setObject(self.txtName.text, forKey: "myName")
                NSUserDefaults.standardUserDefaults().synchronize();
                
                // update profile image
                if object?["image"] != nil {
                    let userImageFile = object?["image"] as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                // Found image
                                self.imageProfile.image = UIImage(data:imageData)
                            }else{
                                // No image
                                print("Debug | updateProfileAndImage@ProfileVC | err:\(error?.userInfo)")
                            }
                        }
                    }
                }else{
                    print("Debug | updateProfileAndImage@ProfileVC | Profile image is nil")

                }
            }
        }
        
        // # update pet amount #
        // Before Update get all of my pet, in gePet() already code to update petAmount at layout
        
        getPet()

    }
    
    func updatePetAmount(totalOfPet totalOfPet:Int){
        print("Updateing pet amount from:\(self.petAmount) to:\(totalOfPet) ")
        self.petAmount = totalOfPet
        self.amountOfPetsLabel.text = "\(totalOfPet)"
    }
    
    func updateFollow(){
        // Update Follower
        print("Updating Follower from \(self.amountOfFollower.text) to \(self.follower)")
        self.amountOfFollower.text = "\(self.follower)"
        // Update Following
        print("Updating Followingfrom \(self.amountOfFollowingLabel.text) to \(self.following)")
        self.amountOfFollowingLabel.text = "\(self.following)"
    }
    
    func getPet(){
        

        // This function get pet object and store values
        // all of pet objects -> petArray
        // number of pets -> petAmount
        print("start getpet() petAmount:\(self.petAmount)")
        
        let query = PFQuery(className: "pet")
        query.whereKey("ownerID", equalTo: self.storedId!)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                // ------------------------------------------------------------------------------------------
                // Update my total of pet value at layout
                self.updatePetAmount(totalOfPet: (pets?.count)!)
                
                // ------------------------------------------------------------------------------------------
                // If user already have pet(s) then save pet object to petsArray for give to PetVC's class
                // Why? because you don't load pet again at PetVC's class
                // ------------------------------------------------------------------------------------------
    
                if pets?.count != 0 {
                    if let pets = pets as [PFObject]! {
                        for pet in pets {
                            
                            // Save pets's object to petsArray here
                            self.petsArray.append(pet)
                        }
                    }
                }else{
                    // Pet.count == 0
                    // When get pet that may be user don't have pet yet?
                    print("Debug | getPetAmount@ProfileVC | pet amount: \(pets?.count)")
                }
            }else{
                // ERROR!! connection fail or Parse server is down?
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        print("end getpet() petAmount:\(self.petAmount)")
        
    }
    
    func getMyFollower(){
        // This function get follower and following object
        
        let query = PFQuery(className: "follower")
        query.whereKey("userID", equalTo: self.storedId!)
        query.findObjectsInBackgroundWithBlock {
            (myFollowers: [PFObject]?, error: NSError?) -> Void in
            print("Get follower : \(myFollowers?.count)")
            self.follower = (myFollowers?.count)!
            self.updateFollow()
        }
        
    }
    
    func getMyFollowing(){
        
        let query = PFQuery(className: "follower")
        query.whereKey("followerID", equalTo: self.storedId!)
        query.findObjectsInBackgroundWithBlock {
            (myFollowings: [PFObject]?, error: NSError?) -> Void in
            print("Get following :\(myFollowings?.count)")
            self.following = (myFollowings?.count)!
            self.updateFollow()
        }
    }
    
    func reloadTable(){
        statusTable.reloadData()
    }
    
    func getPost(fromFunc fromFunc:String){
        // ------------------------------------------------------------------------------------------
        // # Check function was call from ? #
        print("GET post from func:\(fromFunc)")
        // ------------------------------------------------------------------------------------------
        
        let query = PFQuery(className: "post")
        query.whereKey("userID", equalTo: self.storedId!)
        query.findObjectsInBackgroundWithBlock {
            (posts: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if posts?.count != 0 {
                    // Counting posts and save number to postsCount for set number of row in table of posts
                    self.postCount = posts!.count
                    print("Debug | updateProfile@ProfileVC | Successfully retrieved \(posts!.count).")
                    if let posts = posts as [PFObject]! {
                        self.postsArray = [] /* Clear Array before new data */
                        for post in posts {
                            self.postsArray.append(post)
                        }
                        self.reloadTable()
                    }
                }else{
                    // May be posts.count = 0
                    print("Debug | updateProfile@ProfileVC | posts count: \(posts?.count)")
                }
            }else{
                // ERROR is not nil
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    
    // Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "goToProfileSetting") {
            var profileSettingVC: ProfileSettingVC!
            profileSettingVC = segue.destinationViewController as! ProfileSettingVC;
            profileSettingVC.profileImageReceived = self.imageProfile.image
            print("prepareForSegue name:\(self.txtName.text)")
            profileSettingVC.profileNameReceived = self.txtName.text

        }
        
        if (segue.identifier == "goToPetsVC") {
            var petVC: PetsVC!
            petVC = segue.destinationViewController as! PetsVC;
            petVC.petsArrayReceived = self.petsArray
            print("prepareForSegue pet amount:\(self.petAmount)")
            petVC.petAmountReceived = self.petAmount
        }
    }
    
    // TABLE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postCount == 0 {
            return 1
        }else{
            return postCount
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("myStatusCell", forIndexPath: indexPath)

        if self.postCount == 0 {
            cell.textLabel!.text = "Don't have any posts present!"
            cell.detailTextLabel!.text = ""
        } else {
            
            let dateFormat = NSDateFormatter();
            dateFormat.dateFormat = "d-MMM-yyyy"
            
            let date = dateFormat.stringFromDate(self.postsArray[indexPath.row].createdAt!)
            
            dateFormat.dateFormat = "H:m"
            let time = dateFormat.stringFromDate(self.postsArray[indexPath.row].createdAt!)
            let text = self.postsArray[indexPath.row]["text"] as? String
            
            print("TABLE CELL#\(indexPath.row)| text:\(text) | date:\(date) | time:\(time)")
            
            cell.textLabel!.text = text
            cell.detailTextLabel!.text = ("\(date) at \(time)")
        
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("you are select #\(indexPath.row)!")
    }
}

