//
//  SummaryVC.swift
//  Dog Book
//
//  Created by fangchanok on 9/4/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import Parse
class SummaryVC: UIViewController ,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet var myTable: UITableView!
    var AgeList: NSArray {
        let LoadFile = NSBundle.mainBundle().URLForResource("development", withExtension: "plist")
        let Data = NSArray(contentsOfURL: LoadFile!) as NSArray!
        NSBundle.mainBundle()
        return Data!
    }
    var idPet:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNewPet:", name:"setNewPet", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNewPet(notification: NSNotification){
        print("setNewPet")
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        myTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AgeList.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AgeList.objectAtIndex(section).objectForKey("type")!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("cell") as! ProgressCell
        cell.nameProgress.text = AgeList.objectAtIndex(indexPath.section).objectForKey("type")!.objectAtIndex(indexPath.row).objectForKey("name") as? String!
        let query = PFQuery(className: "grow")
        query.whereKey("petId", equalTo: idPet)
        query.whereKey("age", equalTo: indexPath.section)
        query.whereKey("section", equalTo: indexPath.row)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                    cell.myProgress.progress = Float(pets!.count)/Float(self.AgeList.objectAtIndex(indexPath.section).objectForKey("type")!.objectAtIndex(indexPath.row).objectForKey("list")!.count)
            }else{
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AgeList.objectAtIndex(section).objectForKey("age") as? String!
    }
    
    @IBAction func demis(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
