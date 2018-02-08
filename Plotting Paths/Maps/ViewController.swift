//
//  ViewController.swift
//  Maps
//
//  Created by Austin Bailie on 2016-05-09.
//  Copyright © 2016 Austin Bailie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!          // Your common variables
    
    @IBOutlet var longitudeLabel: UILabel!
    
    @IBOutlet var latitudeLabel: UILabel!
    
    @IBOutlet var theSegment: UISegmentedControl!
    
    @IBOutlet weak var segmentBlur: UIVisualEffectView!
   
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var directionLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    var trackSet: Bool = false
    
    var count1 = 0
    
    var count2 = 0
    
    var timer = NSTimer()
    
    var counter = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()                 // Preset attributes E.g location accuracy
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
    }

    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last! as CLLocation     // sets last location as "CLLocation", which is a set of corrdinates in a varaiable
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))  // sets the view of maps to your         
                                                                                                                            // coordinates
        
        self.mapView.setRegion(region, animated: true)
        
        var coordinates = locations.map({ (center: CLLocation) -> CLLocationCoordinate2D in return center.coordinate }) // converts CLLocation to
                                                                                                                        // CLLocation2D to work with drawing

        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count) // takes user coordinates and marks them on map
            
        self.mapView.addOverlay(polyline)
        
        var headingVariable = String() // takes direction on a 10 degree variance
        
        
        if locationManager.location!.course >= 355 && locationManager.location!.course <= 5 {
            
            headingVariable = ("N")
        }
        
        if locationManager.location!.course >= 5 && locationManager.location!.course <= 85 {
            
            headingVariable = ("NE")
        }
        
        if locationManager.location!.course >= 85 && locationManager.location!.course <= 95 {
            
            headingVariable = ("E")
        }
        
        if locationManager.location!.course >= 95 && locationManager.location!.course <= 175 {
            
            headingVariable = ("SE")
        }
        
        if locationManager.location!.course >= 175 && locationManager.location!.course <= 185 {
            
            headingVariable = ("S")
        }
        
        if locationManager.location!.course >= 185 && locationManager.location!.course <= 265 {
            
            headingVariable = ("SW")
        }
        
        if locationManager.location!.course >= 265 && locationManager.location!.course <= 275 {
            
            headingVariable = ("W")
        }
        
        if locationManager.location!.course >= 275 && locationManager.location!.course <= 355 {
            
            headingVariable = ("NW")
        }

        directionLabel.text = ("Heading: " + headingVariable)
       
        latitudeLabel.text = ("Latitude: " + latitudeString(location.coordinate.latitude) )  // inputs into label
        
        longitudeLabel.text = ("Longitude: " + longitudeString(location.coordinate.longitude) )
        
        let speedIrrational = locationManager.location!.speed
        
        let speedRational = Double(round(speedIrrational) * 3.6) // converts from M/S to KM/H
        
        let speedVariable = String(speedRational)
        
        speedLabel.text = ("Speed: " + speedVariable  + " KM/H")
        
        
    }
    
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKPolyline!) -> MKOverlayRenderer! {
        
        if trackSet == true { // attributes of the line being drawn
            
        
            let line = MKPolylineRenderer(overlay: overlay)
            line.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            line.lineWidth = 7
            return line
        }
        
        return nil
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: " + error.localizedDescription)
    }
    
    func latitudeString(latitude:Double) -> String { // converts degrees from decimals to "Degress"Minutes"Seconds"
        var latSeconds = Int(latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60
        return String(format:"%d°%d'%d\"%@",
                      abs(latDegrees),
                      latMinutes,
                      latSeconds,
                      {return latDegrees >= 0 ? "N" : "S"}() )
        
            }
    
    func longitudeString(longitude: Double) -> String {
        var longSeconds = Int(longitude * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let longMinutes = longSeconds / 60
        longSeconds %= 60
        return String(format:"%d°%d'%d\"%@",
                      abs(longDegrees),
                      longMinutes,
                      longSeconds,
                      {return longDegrees >= 0 ? "E" : "W"}() )

        
    }
    
    @IBAction func drawPathTapped(Button1: UIButton) {
        
    
        
        count1 += 1                 // turns on tracking/marking path
        
        print(count1)
        
        if trackSet == false && count1 == 1 {
           
            trackSet = true
            locationManager.startUpdatingLocation()
            
            let attributes = [ NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue,
                               NSFontAttributeName : UIFont.systemFontOfSize(15.0),
                               NSForegroundColorAttributeName : UIColor.blackColor(),]
            
            let attributedString = NSMutableAttributedString(string:"")
            
            
            let buttonTitleStr = NSMutableAttributedString(string:"Mark Path", attributes:attributes)
            attributedString.appendAttributedString(buttonTitleStr)
            Button1.setAttributedTitle(attributedString, forState: .Normal)
            
        }
        
        
        if trackSet == true && count1 == 2 {
            
            
            trackSet = false
            locationManager.stopUpdatingLocation()
            
            let attributes = [ NSFontAttributeName : UIFont.systemFontOfSize(15.0),
                               NSForegroundColorAttributeName : UIColor.blackColor(),]
            
            let attributedString = NSMutableAttributedString(string:"")
            
            
            let buttonTitleStr = NSMutableAttributedString(string:"Mark Path", attributes:attributes)
            attributedString.appendAttributedString(buttonTitleStr)
            Button1.setAttributedTitle(attributedString, forState: .Normal)

            
        }
        
        if count1 >= 2 {
         
            count1 = 0
            
        }
        
    }
    
    @IBAction func centerViewTapped(Button2: UIButton) {
        
        startTimer() // centers the map view on user location when pressed

        self.mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        
        let Lat = Double(mapView.userLocation.coordinate.latitude)
        
        let Long = Double(mapView.userLocation.coordinate.longitude)
        
        
        latitudeLabel.text = ("Latitude: " + latitudeString(Lat))
        
        longitudeLabel.text = ("Longitude: " + longitudeString(Long))
        
    }
    
    func startTimer() { // timer to toggle location updating
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerCount), userInfo: nil, repeats: true)
        print("func startTimer")
        
    }
    
    func stopTimer() {
        
        timer.invalidate()
        counter = 0
        print("func stopTimer")
        
    }
    
    
    func timerCount() {
        
        counter += 1
    
        if counter <= 2 {
            
            locationManager.startUpdatingLocation()
            
        }
        
        if counter >= 2 {
            
            locationManager.stopUpdatingLocation()
            stopTimer()
        }

        print(counter)
        
    }

    
    @IBAction func viewTapped(Button3: UIButton) { // shows types of map styles
        
        count2 += 1
        
        if count2 == 1 {
            
            let attributes = [ NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue,
                               NSFontAttributeName : UIFont.systemFontOfSize(15.0),
                               NSForegroundColorAttributeName : UIColor.blackColor(),]
            
            let attributedString = NSMutableAttributedString(string:"")
            
            
            let buttonTitleStr = NSMutableAttributedString(string:"View", attributes:attributes)
            attributedString.appendAttributedString(buttonTitleStr)
            Button3.setAttributedTitle(attributedString, forState: .Normal)

     
        theSegment.hidden = false
            
        segmentBlur.hidden = false
            
            
        }
        
        if count2 == 2 {
           
        theSegment.hidden = true
            
        segmentBlur.hidden = true
            
            let attributes = [ NSFontAttributeName : UIFont.systemFontOfSize(15.0),
                               NSForegroundColorAttributeName : UIColor.blackColor(),]
            
            let attributedString = NSMutableAttributedString(string:"")
            
            
            let buttonTitleStr = NSMutableAttributedString(string:"View", attributes:attributes)
            attributedString.appendAttributedString(buttonTitleStr)
            Button3.setAttributedTitle(attributedString, forState: .Normal)

            
        }
        
        if count2 >= 2 {
            count2 = 0
        }
        
    
    }
    
    @IBAction func segmentTapped(theSegment: UISegmentedControl) { // shows map styles in segmented display
        
        
            switch (theSegment.selectedSegmentIndex)
            {
            case 0:
                
                self.mapView.mapType = MKMapType.Standard
                break;
                
            case 1:
                
                self.mapView.mapType = MKMapType.Hybrid
                break;
                
            case 2:
                
                self.mapView.mapType = MKMapType.Satellite
                break;
            
            default:
                
                self.mapView.mapType = MKMapType.Standard
                break;
                
                
            }
        
    }
    
      
}




