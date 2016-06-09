//
//  SelectAgeViewController.swift
//  Development
//
//  Created by fangchanok on 8/25/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class SelectAgeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var row:Int = 0
    @IBOutlet weak var myTable: UITableView!
    var delegate: AgePickerDelegate?
var AgeList: NSArray {
        let LoadFile = NSBundle.mainBundle().URLForResource("development", withExtension: "plist")
        let Data = NSArray(contentsOfURL: LoadFile!) as NSArray!
        NSBundle.mainBundle()
        return Data!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return AgeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("AgeCell") as! SelectAgeViewCell
        
        cell.LabelText?.text = AgeList[indexPath.row].objectForKey("age") as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        row = indexPath.row
        if let Send = self.delegate {
            Send.didSelectValueForAge((AgeList[row].objectForKey("age") as? String)! , indexAge:indexPath.row)
        }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
