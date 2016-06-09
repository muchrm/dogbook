//
//  ViewController.swift
//  AroundMe
//
//  Created by Pongpanot Chuaysakun on 7/10/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AroundMe: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate,ChangeMapTypeDelegate{
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    var myLocation:NSArray!
    var test:Int=0
    var locationManager = CLLocationManager()
    var lat:CLLocationDegrees = 13.278805
    var lon:CLLocationDegrees = 100.925479
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        // Do any additional setup after loading the view, typically from a nib.
        
        //mapView.userTrackingMode = .Follow
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lat = locationManager.location!.coordinate.latitude
        lon = locationManager.location!.coordinate.longitude
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon) // .. populate your center
        let latitudinalMeters: CLLocationDistance = 50
        let longitudinalMeters: CLLocationDistance = 50
        let region = MKCoordinateRegionMakeWithDistance(coordinate, latitudinalMeters, longitudinalMeters)
        self.mapView.setRegion(region, animated: false)
        post(["data":"nil"], url: NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&language=th&radius=5000&types=park&key=AIzaSyBF3mC011Pn2EQVr7K0qBIyBh-ZT5aGmEg")!)
        locationManager.stopUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ไม่สามารถระบุตำแหน่งได้")
    }
    
    func parseJSON(data: NSData){
        
        mapView.removeAnnotations(mapView.annotations)
//        var err: NSError?
        do{
            let Dic:NSDictionary! =  try (NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary)
            if Dic["status"] as! String == "OK"{
                
                myLocation =  Dic["results"] as! NSArray
                addArrayToAnnotation(myLocation)
                
            }
        }catch let error as NSError {
            print(error)
        }
        
    }
    
    func post(parameters : Dictionary<String, String>,url: NSURL!){
         self.activityIndicatorView.startAnimating()
        //create the session object
        let session = NSURLSession.sharedSession()
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST" //set http method as POST
        
        var err: NSError?
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        } catch let error as NSError {
            err = error
            print(err)
            request.HTTPBody = nil
        } // pass dictionary to nsdata object and set it as request body
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("Body: \(strData)")
            /*let err: NSError?
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                print(err!.localizedDescription)
            }
            else {*/
                 self.activityIndicatorView.stopAnimating()
                 self.parseJSON(data!)
           // }
        })
        
        task.resume()
    }
        
    func addArrayToAnnotation(arr:NSArray){
        
        for index in arr{
            var name = ""
            let image =  index.objectForKey("types") as! NSArray as! [String]
            if image.indexOf("park") != nil{
                name = "park"
                menuButton.titleLabel?.text = "Park"
                
            }
            else  if image.indexOf("pet_store") != nil {
                name = "pet"
                menuButton.titleLabel?.text = "Pet Store"
            }else if image.indexOf("veterinary_care") != nil {
                name = "vet"
                menuButton.titleLabel?.text = "Veterinary Care"
            }
           
            self.addAnnotation(Lat:index.objectForKey("geometry")!.objectForKey("location")!.objectForKey("lat")!.doubleValue, Long:index.objectForKey("geometry")!.objectForKey("location")!.objectForKey("lng")!.doubleValue,imageUrl:name,Title:index.objectForKey("name")! as! String,SubTitle:index.objectForKey("vicinity")! as! String)
         }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
       
        
    }
    
    func addAnnotation(Lat lat:Double,Long long:Double,imageUrl url:String,Title title:String,SubTitle subTitle:String){
        
        let point:CustomPointAnnotation = CustomPointAnnotation()
        let anno = CLLocationCoordinate2D(latitude: lat, longitude: long)
        point.coordinate = anno
        point.imageurl = url
        point.title = title
        point.subtitle = subTitle
            self.mapView.addAnnotation(point)
        
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let pinView:MKAnnotationView = MKAnnotationView()
        pinView.annotation = annotation
        pinView.canShowCallout = true
        let button : UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        pinView.rightCalloutAccessoryView = button
        let cpl = annotation as! CustomPointAnnotation
        pinView.image = UIImage(named: cpl.imageurl)
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let latitute:CLLocationDegrees =  view.annotation!.coordinate.latitude
        let longitute:CLLocationDegrees =  view.annotation!.coordinate.longitude
        
        //let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
       // let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = view.annotation!.title!
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    
    func didSelectValue(value: String){
        post(["1":"1"], url: NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&language=th&radius=5000&types=\(value)&key=AIzaSyBF3mC011Pn2EQVr7K0qBIyBh-ZT5aGmEg")!)
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! OptionViewController
        vc.delegate = self
    }

}
class CustomPointAnnotation: MKPointAnnotation {
    var imageurl: String!
}