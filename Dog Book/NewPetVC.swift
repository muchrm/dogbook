//
//  NewPetVC.swift
//  PetProfile
//
//  Created by MEITOEY on 7/21/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import UIKit
extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
class NewPetVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtGender: UITextField!
    @IBOutlet var txtColor: UITextField!
    @IBOutlet var txtWeight: UITextField!
    @IBOutlet weak var birthdayText: UIButton!
    var birthday: NSDate!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting date
        setDate()
        // Set default birthday
        setDefaultBirthdayText()
        self.datePicker.hidden = true
        self.birthday = datePicker.date
        
        // Delegate textfiled for hide keyboard 
        self.txtName.delegate = self
        self.txtGender.delegate = self
        self.txtColor.delegate = self
        self.txtWeight.delegate = self

        
        // Do any additional setup after loading the view.
    }
    
    // Hide key board
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dateChange(date: AnyObject){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let str = dateFormatter.stringFromDate(datePicker.date)
        self.birthdayText.setTitle(str, forState: .Normal)
        self.birthday = datePicker.date
    }
    
    @IBAction func birthdayTextTapped(sender: AnyObject){
        if self.datePicker.hidden == true {
            self.datePicker.hidden = false
        }else{
            self.datePicker.hidden = true
        }
    }
    
    func setDefaultBirthdayText(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let str = dateFormatter.stringFromDate(NSDate())
        self.birthdayText.setTitle(str, forState: .Normal)
    }
    
    func setDate(){
        // This Function set default max-min date you can pick
        // Ex. pick birthday date max is today , min is -30 ago
        //
        let currentDate: NSDate = NSDate()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        // let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(name: "UTC")!
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar
        
        components.year = -30
        let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        components.year = 0
        let maxDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        self.datePicker.minimumDate = minDate
        self.datePicker.maximumDate = maxDate
        
        print("minDate: \(minDate)")
        print("maxDate: \(maxDate)")
    }
    
    func CompleteTextField()->Bool{
        
        let name = self.txtName.text
        let gender = self.txtGender.text
        let color = self.txtGender.text
        let weight = self.txtGender.text
        
        if name == nil || gender == nil || color == nil || weight == nil {
            return false
        }else if name?.trim() == "" || gender?.trim() == "" || color?.trim() == "" || weight?.trim() == ""{
            // Miss something
            return false
        }else{
            // Complete all text field was filled
            return true
        }
    }
    
    @IBAction func nextTapped(sender: AnyObject) {
        
        if CompleteTextField() == true {
            performSegueWithIdentifier("goToNewPetImageVC", sender: nil)
        }else{
            // Alert you miss some field ?
            print("Some field is empty | newPetVC")
        }
        

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToNewPetImageVC") {
            let petImageVC = segue.destinationViewController as! NewPetImageVC;
            
            petImageVC.name = self.txtName.text
            petImageVC.color = self.txtColor.text
            petImageVC.weight = self.txtWeight.text
            petImageVC.gender = self.txtGender.text
            petImageVC.birthday = self.birthday
            
            // Pass selected pet profile to petProfileReceived at PetProfile
            //petImageVC.petProfileReceived = self.petsArrayReceived[self.petSelectedIndex]
        }
    }


}

