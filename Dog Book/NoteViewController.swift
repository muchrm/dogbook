//
//  NoteViewController.swift
//  Development
//
//  Created by fangchanok on 8/29/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class NoteViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var myCollection: UICollectionView!
    var noteList:[PFObject]!
    let DateFormat = NSDateFormatter()
    var idPet:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNewPet:", name:"setNewPet", object: nil)
        DateFormat.dateFormat = "d MMMM yyyy"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "note")
        query.whereKey("petid", equalTo: idPet)
        query.findObjectsInBackgroundWithBlock {
            (note: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if note?.count != 0 {
                    self.noteList = note
                    self.myCollection.reloadData()
                }
            }
        }
    }
    
    func setNewPet(notification: NSNotification){
        print("setNewPet")
        idPet = NSUserDefaults.standardUserDefaults().stringForKey("idPet")
        myCollection.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if noteList != nil {
            return noteList.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let ShowDate = DateFormat.stringFromDate(noteList[indexPath.row]["date"]! as! NSDate)
        let cell = myCollection.dequeueReusableCellWithReuseIdentifier("noteCell", forIndexPath: indexPath) as! NoteCell
        cell.myTitle.text = noteList[indexPath.row]["name"]! as? String
        cell.myDate.text = ShowDate
        let petImageFile = noteList[indexPath.row].objectForKey("image") as! PFFile
        petImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.myImage.image = UIImage(data:imageData)
                }
            }
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DisplayNote" {
            let indexPath = myCollection.indexPathForCell(sender as! UICollectionViewCell)
            let nextLink = segue.destinationViewController as! DisplayNoteVC
            let pet = noteList[indexPath!.row]
            nextLink.notePet = pet
        } else if segue.identifier == "EditNote" {
            let TapButton = sender as! UIButton
            let View = TapButton.superview!
            let cell = View.superview as! NoteCell
            let indexPath = myCollection.indexPathForCell(cell)
            let nextLink = segue.destinationViewController as! EditNoteVC
            let pet = noteList[indexPath!.row]
            nextLink.notePet = pet
        } else if segue.identifier == "DeleteNote" {
            let TapButton = sender as! UIButton
            let View = TapButton.superview!
            let cell = View.superview as! NoteCell
            let indexPath = myCollection.indexPathForCell(cell)
            let nextLink = segue.destinationViewController as! DeleteNoteViewController
            nextLink.noteID = noteList[indexPath!.row].objectId!
        }
    }

}
