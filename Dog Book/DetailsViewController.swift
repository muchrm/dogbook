//
//  DetailsViewController.swift
//  Topic
//
//  Created by Pongpanot Chuaysakun on 7/26/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit
import Parse

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var DataTopic: UITextView!
    var topicPet = PFObject(className: "topic")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = topicPet["name"] as? String
        DataTopic.text = topicPet["details"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
