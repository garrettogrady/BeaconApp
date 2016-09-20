//
//  AppDelegate.swift
//  iBeaconTemplateSwift
//
//  Created by Garrett O'Grady 😏
//  Copyright (c) 2015 Fusionary. 👀 :All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

@UIApplicationMain

// meaningless change to test source control

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var lastBeacon: NSNumber?
    let theName = "" as String
    var lastRegionState: CLRegionState?
    var className = "Garto"
    var timer: NSTimer? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D" //beacon ID (changes based on beacon using)
        let beaconIdentifier = "iBeaconModules.us"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        var rootViewController = self.window!.rootViewController as! ViewController
        locationManager = CLLocationManager()
        
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound],
                    categories: nil
                )
            )
        }

        let viewController:ViewController = window!.rootViewController as! ViewController
        let names = viewController.email
        let className = NSUserDefaults.standardUserDefaults()
        className.setValue(names, forKey: "names")
        className.synchronize()
        if let names: AnyObject = className.valueForKey("nameList") {
            
        }

        print(className)
        return true
        
        
    }
    func postToServer(beaconId: Int, beaconName: String, eventAction: String) {
        print(beaconId)
        print(beaconName)
        let eventType = "beacon"
        let viewController:ViewController = window!.rootViewController as! ViewController
        let email = viewController.email
        // create the request & response
        let request = NSMutableURLRequest(URL: NSURL(string: "http://beaconator.fusionarydev.com/api/event")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        let  jsonString = "{\"email\":\"\(email)\",\"beaconId\":\(beaconId),\"beaconName\":\"\(beaconName)\",\"eventAction\":\"\(eventAction)\",\"eventType\":\"beacon\"}"
        
       
            if let strData = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    let json =  try NSJSONSerialization.JSONObjectWithData(strData, options: []) as? [String:AnyObject]
                } catch let error as NSError {
                    print(error)
                }
            }
        
     
        
        // create some JSON data and configure the request
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // send the request
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error1 as NSError {
            error = error1
        }
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            print("HTTP response: \(httpResponse.statusCode)")
        } else {
            print("No HTTP response")
        }
        
        
    }
    //push notification function
    func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // function for ranging beacons
    func locationManager(manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        inRegion region: CLBeaconRegion) {
            let viewController:ViewController = window!.rootViewController as! ViewController
            viewController.beacons = beacons as [CLBeacon]?
            NSLog("didRangeBeacons");
            var message:String = ""
            var beaconName:String?
            let names = viewController.email
            className = names
            let playSound = false
            // if statement to get red of repeat beacon ranges
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0]
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown || lastBeacon == nearestBeacon.minor) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                lastBeacon = nearestBeacon.minor;
                print(nearestBeacon.description)
                //giant if statement to find out which beacon the user is close to based on minor, minor numbers are written on the beacon
                if (nearestBeacon.minor == 1) {
                    message = "You have entered Bryan's Office"
                    beaconName = "Bryan's Office"
                }
                else if (nearestBeacon.minor == 2) {
                    message = "You have entered Steve's Office"
                    beaconName = "Steve's Office"
                }
                else if (nearestBeacon.minor == 3) {
                    message = "You have entered Jacks's Office"
                    beaconName = "Jack's Office"
                }
                else if (nearestBeacon.minor == 4) {
                    message = "You have entered the Conference Room"
                    beaconName = "Conference Room"
                    
                }
                else if (nearestBeacon.minor == 5) {
                    message = "You are by Garrett's Desk"
                    beaconName = "Garrett's Desk"
                }
                else if (nearestBeacon.minor == 6) {
                    message = "You have entered the Kitchen"
                    beaconName = "Kitchen"
                }
                else if (nearestBeacon.minor == 7) {
                    message = "You have entered the Bathroom"
                    beaconName = "Bathroom"
                }
                else if (nearestBeacon.minor == 8) {
                    message = "You have entered the Workspaces"
                    beaconName = "Workspace"
                }
                else if (nearestBeacon.minor == 9) {
                    message = "You have entered the Phone Room"
                    beaconName = "Phone Room"
                }
                
                NSLog("%@", message)
                sendLocalNotificationWithMessage(message, playSound: playSound)
                
            } else {
                
                if(lastProximity == CLProximity.Unknown) {
                    return;
                }
                
                lastProximity = CLProximity.Unknown
                
            }
            let beaconId = 2
            if (beaconName != nil && names != "") {
                postToServer(beaconId, beaconName: beaconName!, eventAction: "enter")
            }
    }
    // function for finding if the user enterted the region
    func locationManager(manager: CLLocationManager,
        didEnterRegion region: CLRegion) {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.startUpdatingLocation()
            NSLog("You entered the region")
            //sendLocalNotificationWithMessage("You entered the region", playSound: false)
            
    }
    // function for finding if the user left the region
    func locationManager(manager: CLLocationManager,
        didExitRegion region: CLRegion) {
            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.stopUpdatingLocation()
            //timer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
            //NSLog("You exited the region")
            print("leaving region")
            let beaconId = 2
            postToServer(beaconId, beaconName: "away", eventAction: "exit")
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let handleShortcutItem = self.handleShortcutItem(shortcutItem)
        completionHandler(handleShortcutItem)
    }
    func applicationDidEnterBackground(application: UIApplication) {
// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.window?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    enum ShortcutIdentifier: String {
        case First
        case Second
        
        init? (fullType: String){
            guard let last = fullType.componentsSeparatedByString(".").last else {return nil}
            self.init(rawValue: last)
        }
        
        var type: String
            {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handle = false
        
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false}
        guard let shortcutType = shortcutItem.type as String? else { return false}
        
        switch (shortcutType)
        {
        case ShortcutIdentifier.First.type:
            handle = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateViewControllerWithIdentifier("FourthViewController")
            self.window?.rootViewController?.presentViewController(navVC, animated: true, completion: nil)
            break
        case ShortcutIdentifier.Second.type:
            handle = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateViewControllerWithIdentifier("FifthViewController")
            self.window?.rootViewController?.presentViewController(navVC, animated: true, completion: nil)
            break
        default:
            break
        }
        
        
        return handle
    }
}


