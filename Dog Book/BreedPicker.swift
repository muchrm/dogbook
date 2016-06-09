//
//  BreedPicker.swift
//  Matching
//
//  Created by Pongpanot Chuaysakun on 7/18/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit


class BreedPicker: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var myBreed: NSArray!
    var delegate: BreedPickerDelegate?
    var breed:String!
        override func viewDidLoad() {
        super.viewDidLoad()
           
            if let path = NSBundle.mainBundle().pathForResource("BreedList", ofType: "plist") {
                myBreed = NSArray(contentsOfFile: path)
                 breed = myBreed[0] as! String
            }
            /*if let dict = myBreed {
                // Use your dict here
            }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return myBreed.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myBreed[row] as? String
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        breed=myBreed[row] as! String
    }
    
    @IBAction func selectBleed(sender: AnyObject) {
        if let d = self.delegate {
            d.didSelectValue(breed) // Get the value from your datasource and return it to the parent through the delegate method.
        }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismiss(gesture: UIGestureRecognizer) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
