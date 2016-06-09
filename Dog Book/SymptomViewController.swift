//
//  SymptomViewController.swift
//  SymptomSearch
//
//  Created by fangchanok on 7/21/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class SymptomViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    var LinkCategory = PFObject(className: "symptom")
    var dataList:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = LinkCategory["name"] as? String
        let query = PFQuery(className: "symptomData")
        query.whereKey("details", containsString: LinkCategory["name"] as? String)
        query.findObjectsInBackgroundWithBlock {
            (topic: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if topic?.count != 0 {
                    self.dataList = topic
                    self.myTable.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "symptomData")
        query.whereKey("details", containsString: LinkCategory["name"] as? String)
        query.findObjectsInBackgroundWithBlock {
            (topic: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if topic?.count != 0 {
                    self.dataList = topic
                    self.myTable.reloadData()
                }
            }
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataList != nil) {
            return dataList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("DataCell") as! SymptomViewCell
        
        cell.ImageDog.image = UIImage(named: "")
        cell.Details.text = dataList[indexPath.row]["details"] as? String
        [cell.Details .sizeToFit()]
        return cell
        
    }
}
