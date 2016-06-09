//
//  ApiManager.swift
//  PetProfile
//
//  Created by MEITOEY on 7/22/2558 BE.
//  Copyright (c) 2558 MEITOEY. All rights reserved.
//

import Foundation

class ApiManager {
    
    // Url path
    private var loginUrl: String = ""
    private var registerUrl: String = ""
    private var profileUrl: String = ""
    private var timelineUrl: String = ""
    private var messageUrl: String = ""
    private var petUrl: String = ""
    private var followUrl: String = ""


    
    init(){
        // println("created api manager")
        self.loginUrl = "http://angsila.cs.buu.ac.th/~55160217/app/login.php/"
        self.registerUrl = "http://angsila.cs.buu.ac.th/~55160217/app/signup.php/"
        self.profileUrl = "http://angsila.cs.buu.ac.th/~55160217/app/profile.php/"
        self.timelineUrl = "http://angsila.cs.buu.ac.th/~55160217/app/timeline.php/"
        self.messageUrl = "http://angsila.cs.buu.ac.th/~55160217/app/message.php/"
        self.petUrl = "http://angsila.cs.buu.ac.th/~55160217/app/pet.php/"
        self.followUrl = "http://angsila.cs.buu.ac.th/~55160217/app/follow.php/"

    }
    
    func registing(email email: String, password: String, username: String) -> NSDictionary{
        let url = "\(self.registerUrl)?email=\(email)&password=\(password)&username=\(username)"
        // println(url)
        return parseJSON( getJSON( url ) )
        
    }
    
    func authen(email email: String, password: String) -> NSDictionary{
        let url = "\(self.loginUrl)?email=\(email)&password=\(password)"
        // println(url)
        return parseJSON( getJSON( url ) )
    }
    
    func updateName(id id: String, name: String) -> NSDictionary{
        let url = "\(self.profileUrl)?updateId=\(id)&name=\(name)"
        print(url)
        return parseJSON( getJSON( url ) )

    }
    
    func getProfile(id id: String) -> NSDictionary{
        let url = "\(self.profileUrl)?id=\(id)"
        // println(url)
        return parseJSON( getJSON( url ) )
    }
    
    func getProfile(email email: String) -> NSDictionary{
        let url = "\(self.profileUrl)?email=\(email)"
        // println(url)
        return parseJSON( getJSON( url ) )
    }
    
    // TIMELINE 
    func getPost(userId userId: String) -> NSArray{
        let url = "\(self.timelineUrl)?getStatus=yes&userId=\(userId)"
        print(url)
        return parseArrJSON( getArrJSON( url ) )
    }
    
    func createPost(userId userId: String, text: String, image: String, date: String ) -> NSDictionary{
        let url = "\(self.timelineUrl)?createStatus=yes&text=\(text)&image=\(image)&date=\(date)&userId=\(userId)"
        print(url)
        return parseJSON( getJSON( url ) )
    }
    
    func listUserProfile()->NSArray{
        let url = "\(profileUrl)?id=*"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func getMessage(from from: String, to: String)->NSArray{
        let url = "\(messageUrl)?get=yes&from=\(from)&to=\(to)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func sendMessage(from from: String, to: String, msg: String)->NSDictionary{
        let url = "\(messageUrl)?send=yes&from=\(from)&to=\(to)&text_msg=\(msg)"
        print(url)
        return parseJSON( getJSON( url ) )
    }
    
    func getPet(id id: String)->NSArray{
        let url = "\(petUrl)?get=yes&petId=\(id)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func getMyPet(id id: String)->NSArray{
        let url = "\(petUrl)?get=yes&owner=\(id)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func addPet(name name: String, gender: String, birthday: String, color: String, weight: String, image: String, owner: String)->NSArray{
        let url = "\(petUrl)?add=yes&name=\(name)&gender=\(gender)&birthday=\(birthday)&color=\(color)&weight=\(weight)&image=\(image)&owner=\(owner)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    // FOLLOW
    
    func getFollow(id id: String)->NSArray{
        let url = "\(followUrl)?getFollower=yes&userId=\(id)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func getFollowing(id id: String)->NSArray{
        let url = "\(followUrl)?getFollowing=yes&userId=\(id)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func addFollower(following following: String, Follower: String){
        let url = "\(followUrl)?addFollower=yes&followerId=\(Follower)&followingId=\(following)"
        print(url)
        parseArrJSON( getJSON( url ) )
    }
    
    func checkFollow(following following: String, Follower: String)->NSArray{
        let url = "\(followUrl)?checkFollow=yes&followerId=\(Follower)&followingId=\(following)"
        print(url)
        return parseArrJSON( getJSON( url ) )
    }
    
    func unFollower(following following: String, Follower: String){
        let url = "\(followUrl)?unFollow=yes&followerId=\(Follower)&followingId=\(following)"
        print(url)
        parseArrJSON( getJSON( url ) )
    }
    
    // PET 
    
    func updatePetProfile(id id:String, name:String, gender:String, birthday:String, color:String, weight:String){
        
        let url = "\(petUrl)?update=yes&petId=\(id)&name=\(name)&gender=\(gender)&birthday=\(birthday)&color=\(color)&weight=\(weight)"
        
        // Do update
        httpRequest(url)
        
    }
    
    // HTTP REQUEST
    
    func httpRequest(urlToRequest: String){
        print("Make Http Request.. ")
        let url = urlToRequest.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print("URL: \(url)")
        NSData(contentsOfURL: NSURL(string: url)!)!
    }
    
    // MARK : -- Connect JSON
    func getJSON(urlToRequest: String) -> NSData{
        
        let url = urlToRequest.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print("URL: \(url)")
        return NSData(contentsOfURL: NSURL(string: url)!)!

    }
    
    func parseJSON(data: NSData) -> NSDictionary{
        var result = NSDictionary()
        do{
            result = try (NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary)!

        }catch let err as NSError {
            print(err)
        }
        return result
    }
    //
    
    
    func getArrJSON(urlToRequest: String) -> NSData{
        
        let url = urlToRequest.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return NSData(contentsOfURL: NSURL(string: url)!)!
    }
    
    func parseArrJSON(data: NSData) -> NSArray{
        return (try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as! NSArray
    }
    
}