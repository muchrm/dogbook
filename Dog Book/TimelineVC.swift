//
//  TimelineVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
import Parse
class TimelineVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var posts: NSArray!
    
    @IBOutlet var timelineTable: UITableView!
    var storedId: String!
    var postsCount: Int = 0
    var postsArray: [PFObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        print("Debug | viewDidLoad@Timeline | ID \(self.storedId)")
        // No underline table cell
        //self.timelineTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Get posts 
        //getPost()
        
        // Set Table
        self.timelineTable.rowHeight = UITableViewAutomaticDimension
        self.timelineTable.estimatedRowHeight = 160
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Reaload ID again
        print("Debug | viewDidAppear@Timeline | Reload ID Again \(self.storedId)")
        self.storedId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        // Get post again after view appear
        getPost()
    }
    
    func reloadTable(){
        // reload data
        timelineTable.reloadData()
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func newStatusTapped(sender: UIButton) {
        // go to new status
    }
    
    func getPost(){
        
        let query = PFQuery(className: "post")
        query.whereKey("userID", equalTo: self.storedId!)
        query.findObjectsInBackgroundWithBlock {
            (posts: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if posts?.count != 0 {
                    // Update table count
                    self.postsCount = (posts?.count)!
                    print("Debug | getPost@TimelineVC | Successfully retrieved \(posts!.count).")
                    if let posts = posts as [PFObject]! {
                        self.postsArray = [] /* Clear Array before pass new data to array */
                        for post in posts {
                            self.postsArray.append(post)
                        }
                        self.reloadTable()
                    }
                }else{
                    print("Debug | getPost@TimelineVC | Posts is Zero count: \(posts?.count)")
                }
            }else{
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    func getNameFromId(id id:String)->String{
        var name:String = "nil"
        
        let query = PFQuery(className: "user")
        query.whereKey("objectId", equalTo: id)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
            } else {
                // The find succeeded.
                name = (object!["name"] as? String)!
                print("Successfully retrieved the object.\(name)")
            }
        }
        return name

    }
    
    // overide
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Debug | tableView@TimelineVC | Posts count:\(postsCount).")
        if self.postsCount == 0 {
            return 1
        }else{
            return self.postsCount
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if self.postsCount == 0 {
            // Default is No image
            let cell = tableView.dequeueReusableCellWithIdentifier("statusPostCell", forIndexPath: indexPath) as? StatusPostCell
            cell!.name.text = ""
            cell!.time.text = ""
            cell!.postText.text = "Don't have any status present"
            return cell!
        
        }else{
            //
            // Formating time
            //
            let dateFormat = NSDateFormatter();
            dateFormat.dateFormat = "d-MMM-yyyy"
            
            let date = dateFormat.stringFromDate(self.postsArray[indexPath.row].createdAt!)
            dateFormat.dateFormat = "H:m"
            
            let time = dateFormat.stringFromDate(self.postsArray[indexPath.row].createdAt!)
            let text = self.postsArray[indexPath.row]["text"] as? String
            //let name = getNameFromId(id: (self.postsArray[indexPath.row]["userID"] as? String)!)
            /*
            *
            */
            
            if self.postsArray[indexPath.row]["image"] != nil {
                let cellWithImage = tableView.dequeueReusableCellWithIdentifier("statusPostWithImageCell", forIndexPath: indexPath) as? StatusPostWithImageCell
                
                
                cellWithImage!.time.text = ("\(date) at \(time)")
                cellWithImage!.postText.text = text
                cellWithImage!.name.text = "name"//name

                // Got image
                let id = self.postsArray[indexPath.row]["userID"] as! String
                
                let query = PFQuery(className: "user")
                query.whereKey("objectId", equalTo: id)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        cellWithImage!.name.text = (object!["name"] as? String)!
                        print("Successfully retrieved the object.\(cellWithImage!.name.text)")
                    }
                }
                
                // Get image from Parse server here
                if self.postsArray[indexPath.row]["image"] != nil {
                    let userImageFile = self.postsArray[indexPath.row]["image"] as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                // Found image
                                cellWithImage!.postImage!.image = UIImage(data:imageData)
                            }else{
                                // No image, Do notting
                            }
                        }
                    }
                }
                
                
                cellWithImage?.postText.numberOfLines = 0
                cellWithImage?.postText.lineBreakMode = .ByWordWrapping
                return cellWithImage!

            }else{
                let basicCell = tableView.dequeueReusableCellWithIdentifier("statusPostCell", forIndexPath: indexPath) as? StatusPostCell
                
                // Got image
                let id = self.postsArray[indexPath.row]["userID"] as! String
                
                let query = PFQuery(className: "user")
                query.whereKey("objectId", equalTo: id)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        basicCell!.name.text = (object!["name"] as? String)!
                        print("Successfully retrieved the object.\(basicCell!.name.text)")
                    }
                }
                basicCell!.postText.text = text
                basicCell!.time.text = ("\(date) at \(time)")
                // Debug
                print("TABLE CELL#\(indexPath.row)| text:\(text) | date:\(date) | time:\(time)")
                
                basicCell?.postText.numberOfLines = 0;
                basicCell?.postText.lineBreakMode = .ByWordWrapping
                
                return basicCell!
            }
            
            

        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("you are select #\(indexPath.row)!", terminator: "")
    }


}
