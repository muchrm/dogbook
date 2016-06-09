//
//  TopicViewController.swift
//  Topic
//
//  Created by fangchanok on 7/13/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class TopicViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    var Topic_TitleLink:String!
    var Topic_TypeLink:String!
    var idUser:String!
    var topicList:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Topic_TitleLink
        print(Int(Topic_TypeLink)!)
        idUser = NSUserDefaults.standardUserDefaults().stringForKey("userId")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "topic")
        query.whereKey("category", equalTo: Int(Topic_TypeLink)!)
        query.findObjectsInBackgroundWithBlock {
            (topic: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if topic?.count != 0 {
                    self.topicList = topic
                    self.myTable.reloadData()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(topicList != nil) {
            print("\(topicList.count)")
            return topicList.count
        } else {
            print("00000000")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("TopicCell") as! TopicViewCell

        cell.TopicName.text = topicList[indexPath.row]["name"] as? String
        cell.TopicVotes.text = topicList[indexPath.row]["vote"] as? String
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = myTable.indexPathForCell(sender as! UITableViewCell)
        let nextLink = segue.destinationViewController as! DetailsViewController
        let top = topicList[indexPath!.row]
        nextLink.topicPet = top
    }

}
