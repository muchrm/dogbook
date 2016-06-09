//
//  CategoryViewController.swift
//  SymptomSearch
//
//  Created by fangchanok on 7/21/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class CategoryViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var myTable: UITableView!
    var symptomList:[PFObject]!
    var idUser:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "symptom")
        query.findObjectsInBackgroundWithBlock {
            (symptom: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if symptom?.count != 0 {
                    self.symptomList = symptom
                    self.myTable.reloadData()
                }
            }
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(symptomList != nil) {
            return symptomList.count
        } else {
            return 0
        }
        //return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("SymptomCell") as! CategoryViewCell
        
        cell.SymptomName.text = symptomList[indexPath.row]["name"] as? String
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = myTable.indexPathForCell(sender as! UITableViewCell)
        let nextLink = segue.destinationViewController as! SymptomViewController
        let data = symptomList[indexPath!.row]
        nextLink.LinkCategory = data
        
        
    }
}
