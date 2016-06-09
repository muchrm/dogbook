//
//  CategoryViewController.swift
//  Topic
//
//  Created by fangchanok on 7/13/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class TopicCategoryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var myTable: UITableView!
    
    var TypeList: [[String:String]] {
        let LoadFile = NSBundle.mainBundle().URLForResource("Category", withExtension: "plist")
        let Data = NSArray(contentsOfURL: LoadFile!) as? [[String: String]]
        NSBundle.mainBundle()
        return Data!
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
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
        
        if(TypeList[0]["Type"] != nil) {
            return TypeList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("CategoryCell") as! TopicCategoryViewCell
        
        cell.CategoryName.text = TypeList[indexPath.row]["TypeName"]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = myTable.indexPathForCell(sender as! UITableViewCell)
        let LinkCell = segue.destinationViewController as! TopicViewController
        
        LinkCell.Topic_TitleLink = TypeList[indexPath!.row]["TypeName"]!
        LinkCell.Topic_TypeLink = TypeList[indexPath!.row]["Type"]!
    }


}
