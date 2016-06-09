//
//  CuresViewController.swift
//  Development
//
//  Created by fangchanok on 8/30/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class CuresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTable: UITableView!
    let DateFormat = NSDateFormatter()
    var cureList:[PFObject]!
    var idPet:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNewPet:", name:"setNewPet", object: nil)
        DateFormat.dateFormat = "d MMM yy"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "cure")
        query.whereKey("petid", equalTo: idPet)
        query.findObjectsInBackgroundWithBlock {
            (note: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if note?.count != 0 {
                    self.cureList = note
                    self.myTable.reloadData()
                }
            }
        }

    }
    
    func setNewPet(notification: NSNotification){
        print("setNewPet")
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        myTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cureList != nil {
            return cureList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ShowDate = DateFormat.stringFromDate(cureList[indexPath.row]["date"]! as! NSDate)
        let cell = myTable.dequeueReusableCellWithIdentifier("CuresCell") as! CuresVCell
        cell.mySymptom.text = cureList[indexPath.row]["name"]! as? String
        cell.DetailsSym.text = cureList[indexPath.row]["details"]! as? String
        cell.myDate.text = ShowDate
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DisplayCures" {
            let indexPath = myTable.indexPathForCell(sender as! UITableViewCell)
            let nextLink = segue.destinationViewController as! DisplayCuresVC
            
            let pet = cureList[indexPath!.row]
            nextLink.curePet = pet
            
        } else if segue.identifier == "EditCures" {
            let TapButton = sender as! UIButton
            let View = TapButton.superview!
            let cell = View.superview as! CuresVCell
            let indexPath = myTable.indexPathForCell(cell)
            print(indexPath!.row)
            let nextLink = segue.destinationViewController as! EditCuresVC
            
            let pet = cureList[indexPath!.row]
            nextLink.curePet = pet
            
        } else if segue.identifier == "DeleteCures" {
            let TapButton = sender as! UIButton
            let View = TapButton.superview!
            let cell = View.superview as! CuresVCell
            let indexPath = myTable.indexPathForCell(cell)
            let nextLink = segue.destinationViewController as! DeleteNoteViewController
            nextLink.cureID = cureList[indexPath!.row].objectId!
        }
    }

}
