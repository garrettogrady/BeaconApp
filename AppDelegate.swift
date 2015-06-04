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

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var lastBeacon: NSNumber?
    let theName = "" as String
    var outOfRegion = false
    var lastRegionState: CLRegionState?
    var exitMessage = ""
    var enterMessage = ""
    var className = "Garto"


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
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil))
        }
        
        let viewController:ViewController = window!.rootViewController as! ViewController
        var names = viewController.theName
        let className = NSUserDefaults.standardUserDefaults()
        className.setValue(names, forKey: "names")
        className.synchronize()
        if let names: AnyObject = className.valueForKey("highscore") {
            // do something here when a highscore exists
        }
        else {
            // no highscore exists
        }
        println(className)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
}

extension AppDelegate: CLLocationManagerDelegate {
    func postToSlack(message2: String, name: String) {
        var channel = "#botspam"
        let username = name + "'s spyBot" 
        let text = message2
        let image = ":eyes:"
        //payload array
        let str = "payload={\"channel\": \"\(channel)\", \"username\": \"\(username)\", \"text\": \"\(text)\", \"icon_emoji\": \"\(image)\"}"
        
        // converting to JSON
        let strData = (str as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        //Fusionary web hook
        let url = NSURL(string: "https://fusionary.slack.com/services/hooks/incoming-webhook?token=XdberBh1PFWVTLfZ0p27WoHW")
        var request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        //checking to see if array is valid JSON
        var error : NSError? = nil
        if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: &error) {
            let results = NSString(data:data, encoding:NSUTF8StringEncoding)
            println(results)
        }
        else
        {
            println("data invalid")
            println(error)
        }
    }

    func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            let viewController:ViewController = window!.rootViewController as! ViewController
            viewController.beacons = beacons as! [CLBeacon]?
            viewController.tableView!.reloadData()
            NSLog("didRangeBeacons");
            var message:String = ""
            var names = viewController.theName
            className = names
            var playSound = false
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as! CLBeacon
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown || lastBeacon == nearestBeacon.minor) {
                    return;
                }
                lastProximity = nearestBeacon.proximity;
                lastBeacon = nearestBeacon.minor;

                if (nearestBeacon.minor == 1) {
                    message = names + " is in Bryan's office"
                }
                else if (nearestBeacon.minor == 2) {
                   message = names + " is in Steve's office"
                }
                else if (nearestBeacon.minor == 3) {
                   message = names + " is in Jacks's office"
                }
                else if (nearestBeacon.minor == 4) {
                   message = names + " is in the conference room"
                }
                else if (nearestBeacon.minor == 5) {
                   message = names + " is by garrett's desk"                   
                }
                else if (nearestBeacon.minor == 6) {
                    message = names + " is in the kitchen"
                }
                else if (nearestBeacon.minor == 7) {
                    message = names + " is in the bathroom"
                }
                else if (nearestBeacon.minor == 8) {
                    message = names + " is at the workspaces"
                }

                NSLog("%@", message)
                sendLocalNotificationWithMessage(message, playSound: playSound)

            } else {
                
                if(lastProximity == CLProximity.Unknown) {
                    return;
                }
                
                lastProximity = CLProximity.Unknown
            }
            postToSlack(message, name: names)
        }
    
    // function checking if user is in range of the beacon
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.startUpdatingLocation()
            outOfRegion = false
            NSLog("you entered the region")
          }
    
    // function that checks if the user is out of the region
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            outOfRegion = true
            manager.startMonitoringSignificantLocationChanges()
            let start = NSDate(); // <<<<<<<<<< Start time
            var names = className
            if (!inOffice) {
                println("not in office")
                var text = names + " has left the office"
                //postToSlack(text, name: names)
                //NSLog("You exited the region")
                //sendLocalNotificationWithMessage("You exited the region", playSound: true)
            }
        }
}

