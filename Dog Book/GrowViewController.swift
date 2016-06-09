//
//  GrowViewController.swift
//  Development
//
//  Created by fangchanok on 8/27/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse
class GrowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AgePickerDelegate,DatePickerDelegate{

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var ButtonAges: UIButton!
    var AgeList: NSArray {
        let LoadFile = NSBundle.mainBundle().URLForResource("development", withExtension: "plist")
        let Data = NSArray(contentsOfURL: LoadFile!) as NSArray!
        NSBundle.mainBundle()
        return Data!
    }
    var indexAge:Int!
    var indexCell:NSIndexPath!
    var idPet:String!
    var birthPet:NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        indexAge = 0
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        birthPet = NSUserDefaults.standardUserDefaults().objectForKey("datePet") as! NSDate
        ButtonAges.setTitle(AgeList.objectAtIndex(indexAge).objectForKey("age") as! String!, forState: UIControlState.Normal)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNewPet:", name:"setNewPet", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectValueForAge(nameAge: String , indexAge:Int) {
        //println(value)
        ButtonAges.setTitle(nameAge, forState: UIControlState.Normal)
        self.indexAge = indexAge
        self.myTable.reloadData()
    }
    func didSelectValue(value: NSDate) {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "d MMM yyyy"
        let cell = myTable.cellForRowAtIndexPath(indexCell) as! GrowCell
        cell.dateLabel.text = dateFormat.stringFromDate(value)
    }
    func setNewPet(notification: NSNotification){
        print("setNewPet")
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        birthPet = NSUserDefaults.standardUserDefaults().objectForKey("datePet") as! NSDate
        print("idpet="+idPet)
        print(birthPet)
        myTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AgeList.objectAtIndex(indexAge).objectForKey("type")!.count!
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AgeList.objectAtIndex(indexAge).objectForKey("type")!.objectAtIndex(section).objectForKey("name") as! String!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AgeList.objectAtIndex(indexAge).objectForKey("type")!.objectAtIndex(section).objectForKey("list")!.count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("DogCell") as! GrowCell
        cell.descLabel.text = AgeList.objectAtIndex(indexAge).objectForKey("type")?.objectAtIndex(indexPath.section).objectForKey("list")?.objectAtIndex(indexPath.row).objectForKey("name") as! String!
        let date = NSDate()
        let dateFormat = NSDateFormatter();
        dateFormat.dateFormat = "d MMM yyyy"
        cell.dateLabel.text = dateFormat.stringFromDate(date)
        cell.dateLabel.text = dateFormat.stringFromDate(date)
        cell.mySwitch.on = false
        cell.ageLabel.hidden = true
        let query = PFQuery(className: "grow")
        query.whereKey("petId", equalTo: idPet)
        query.whereKey("age", equalTo: indexAge)
        query.whereKey("section", equalTo: indexPath.section)
        query.whereKey("row", equalTo: indexPath.row)
        query.findObjectsInBackgroundWithBlock {
            (pets: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if pets?.count != 0 {
                    print("Debug |papo yo!| GrowVC | Successfully retrieved \(pets!.count ).")
                    if let pet = pets?.first{
                        let getDate = pet["date"] as! NSDate!
                        cell.ageLabel.text = "อายุที่ทำได้ "+String(getDate!.yearsFrom(self.birthPet))+" ปี "+String(getDate!.monthsFrom(self.birthPet)%12)+" เดือน "+String(getDate!.daysFrom(self.birthPet)%30)+" วัน"
                        cell.dateLabel.text = dateFormat.stringFromDate(getDate!)
                        cell.ageLabel.hidden = false
                    }
                    cell.mySwitch.on = true
                    }else{
                    print("Debug |Miniun| GrowVC | posts count: \(pets!.count)")
                }
            }else{
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        return cell
    }

    @IBAction func switchPress(sender: AnyObject) {
        let sw = sender as! UISwitch
        let view = sw.superview!
        let cell = view.superview as! GrowCell
        indexCell = myTable.indexPathForCell(cell)!
        
            if sw.on == true {
                print("on")
                cell.ageLabel.hidden = false
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy"
                let date = dateFormatter.dateFromString(cell.dateLabel.text!)
                let grow = PFObject(className: "grow")
                grow["petId"] = idPet
                grow["age"] = indexAge
                grow["section"] = indexCell.section
                grow["row"] = indexCell.row
                grow["date"] = date
                grow.saveInBackground()
            }else{
                print("off")
                cell.ageLabel.hidden = true
                let query = PFQuery(className: "grow")
                query.whereKey("petId", equalTo: idPet)
                query.whereKey("age", equalTo: indexAge)
                query.whereKey("section", equalTo: indexCell.section)
                query.whereKey("row", equalTo: indexCell.row)
                query.findObjectsInBackgroundWithBlock {
                    (pets: [PFObject]?, error: NSError?) -> Void in
                    if error == nil{
                        PFObject.deleteAllInBackground(pets)
                    }
                }
            }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ageSelect" {
            let AgePick = segue.destinationViewController as! SelectAgeViewController
            AgePick.delegate = self
        }else if segue.identifier == "dateSelect"{
            let bt = sender as! UIButton
            let view = bt.superview!
            let cell = view.superview as! GrowCell
            indexCell = myTable.indexPathForCell(cell)!
            let datePick = segue.destinationViewController as! DateView
            datePick.delegate = self
        }else if segue.identifier == "ShowDesCription"{
            let bt = sender as! UIButton
            let view = bt.superview!
            let cell = view.superview as! GrowCell
            let indexPath = myTable.indexPathForCell(cell)!
            let view2 = segue.destinationViewController as! showGrowInfo
            let text = AgeList.objectAtIndex(indexAge).objectForKey("type")?.objectAtIndex(indexPath.section).objectForKey("list")?.objectAtIndex(indexPath.row).objectForKey("description") as! String!
            view2.growInfo = "    \(text!)"
        }
        
    }
}
