//
//  ViewController.swift
//  iBeaconTemplateSwift
//
//  Created by Garrett O'Grady on 😏.
//  Copyright (c) 2015 Fusionary. 👀 :All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import MapKit

var inOffice = true
var outOffice = false

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet var tableView: UITableView?
    
    var theName:String = ""
    var beacons: [CLBeacon]?
    var userName: NSString = ""
    var label: UILabel = UILabel()
    let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var locationManager = CLLocationManager()
    var logInView = UIView(frame: CGRectMake(100, 100, 100, 100))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        var latitude:CLLocationDegrees = 42.958935
        var longitude:CLLocationDegrees = -85.672985
        var latDelta:CLLocationDegrees = 0.001
        var lonDelta:CLLocationDegrees = 0.001
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        //Do any additional setup after loading the view, typically from a nib.
        label.frame = CGRectMake(210, 525, 100, 50)
        label.textColor = UIColor.blueColor()
        label.textAlignment = NSTextAlignment.Right
        var viewName = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
        label.text = viewName
        self.view.addSubview(label)
        button.frame = CGRectMake(5, 525, 100, 50)
        button.setTitle("Change Name", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)

    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("hey")
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation: CLLocation = locations[0] as! CLLocation
        var userLatitude = userLocation.coordinate.latitude
        var userLongitude = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        var latitude:CLLocationDegrees = 42.958975
        var longitude:CLLocationDegrees = -85.672868
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let myLocation = CLLocation(latitude: latitude , longitude: longitude)
        let distance = userLocation.distanceFromLocation(myLocation)
        println(distance)
        if distance > 5 {
            inOffice = false
        }
        else {
            outOffice = false
        
        }
    }

    func buttonAction(sender:UIButton!)
    {
        var alertController = UIAlertController(
            title: "Name",
            message: "Please enter your name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        var okAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.Default) {
                (action) -> Void in
                println("You entered \((alertController.textFields?.first as! UITextField).text)")
                self.theName = (alertController.textFields?.first as! UITextField).text
                NSUserDefaults.standardUserDefaults().setObject(self.theName, forKey: "permName")
                self.label.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String

        }
    
        var cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.Cancel) {
                (action) -> Void in
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (txtEmail) -> Void in
            txtEmail.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        if ((NSUserDefaults.standardUserDefaults().objectForKey("permName")) == nil) {
        var alertController = UIAlertController(
            title: "Name",
            message: "Please enter your name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        var okAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.Default) {
                (action) -> Void in
                println("You entered \((alertController.textFields?.first as! UITextField).text)")
                self.theName = (alertController.textFields?.first as! UITextField).text
                NSUserDefaults.standardUserDefaults().setObject(self.theName, forKey: "permName")
                self.label.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
        }
        var cancelAction = UIAlertAction(
                title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    (action) -> Void in      
            }

        alertController.addTextFieldWithConfigurationHandler {
            (txtEmail) -> Void in
            txtEmail.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String

        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
            
        self.presentViewController(alertController, animated: true, completion: nil)
        
        }
        else {
            self.theName = (NSUserDefaults.standardUserDefaults().objectForKey("permName") as! String)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if(beacons != nil) {
                return beacons!.count
            }
            else {
                return 0
            }
    }
    // updating the view table with the proximity of the user to the beacon
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell:UITableViewCell? =
            tableView.dequeueReusableCellWithIdentifier("MyIdentifier") as? UITableViewCell
            
            if(cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyIdentifier")
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
            }
            
            let beacon:CLBeacon = beacons![indexPath.row]
            var proximityLabel:String! = ""
            var beaconLabel:String! = "hey"
            
            if (beacon.minor == 1) {
                beaconLabel = "Bryan's Office"
            }
            else if (beacon.minor == 2) {
                beaconLabel = "Steve's Office"
            }
            else if (beacon.minor == 3) {
                beaconLabel = "Jack's Office"
            }
            else if (beacon.minor == 4) {
                beaconLabel = "Conference Room"
            }
            else if (beacon.minor == 5) {
                 beaconLabel = "Garrett's Desk"
            }
            else if (beacon.minor == 6) {
                beaconLabel = "Kitchen"
            }
            else if (beacon.minor == 7) {
                beaconLabel = "Bathroom"
            }
            else if (beacon.minor == 8) {
                beaconLabel = "Workspace"
            }
            
            cell!.textLabel!.text = beaconLabel
            let detailLabel:String = "Major: \(beacon.major.integerValue), " +
                "Minor: \(beacon.minor.integerValue), " +
                "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
            cell!.detailTextLabel!.text = detailLabel
            return cell!
    }
}