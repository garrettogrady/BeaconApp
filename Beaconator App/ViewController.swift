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

var rowCounter:Int = 0
var selectedRow = 0


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    var repositories = [Repository]()
    var email:String = ""
    var beacons: [CLBeacon]?
    var label: UILabel = UILabel()
    let button = UIButton(type: UIButtonType.System)
    var locationManager = CLLocationManager()
    var secondJustLocation = ""
    var secondNameLabel = ""
    var secondLocationLabel = ""
    var secondTime = ""
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        print("LOADING FIRST VIEW")
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.frameForAlignmentRect(CGRectMake(0, 30, 30, 30))
        //refreshControl.center = CGPointMake(tableView.frame.size.width / 2, tableView.frame.size.height / 2)
        tableView.addSubview(refreshControl)
        print("recieving event")
        recieveEvent()
    

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        label.frame = CGRectMake(screenWidth-160,screenHeight-34, 150, 30)
        label.textColor = UIColor(hue: 0.5167, saturation: 0.4, brightness: 0.99, alpha: 1.0)
        label.textAlignment = NSTextAlignment.Right
        let viewName = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
        label.text = viewName
        self.view.addSubview(label)
        
        button.frame = CGRectMake(5, screenHeight-34, 100, 30)
        button.setTitle("Change Email", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = UIColor(hue: 0.5167, saturation: 0.4, brightness: 0.99, alpha: 1.0)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
        self.view.addSubview(button)
        
        
        
        //if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: tableView)
        //}
    }
    
    func recieveEvent() {
        if let path = NSBundle.mainBundle().pathForResource("Locations", ofType: "json") {
            do {
                let JSONData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                if let json = (try? NSJSONSerialization.JSONObjectWithData(JSONData, options: [])) as? NSDictionary {
                    // 4
                    print("step 4")
                    if let reposArray = json["items"] as? [NSDictionary] {
                        // 5
                        print("step 5")
                        for item in reposArray {
                            repositories.append(Repository(json: item))
                        }
                    }
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
//        let reposURL = NSURL(string: "https://api.myjson.com/bins/439t6")
//        // 2
//        print("step 2")
//        if let JSONData = NSData(contentsOfURL: reposURL!) {
//            // 3
//            print("step 3")
//            if let json = (try? NSJSONSerialization.JSONObjectWithData(JSONData, options: [])) as? NSDictionary {
//                // 4
//                print("step 4")
//                if let reposArray = json["items"] as? [NSDictionary] {
//                    // 5
//                    print("step 5")
//                    for item in reposArray {
//                        repositories.append(Repository(json: item))
//                    }
//                }
//            }
//        }

    }

    func refresh(sender:AnyObject)
    {
        repositories.removeAll(keepCapacity: false)
        self.recieveEvent()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    
    func buttonAction(sender:UIButton!) {
    let alertController = UIAlertController(
    title: "Email",
    message: "Please enter your Email",
    preferredStyle: UIAlertControllerStyle.Alert)
    
    let okAction = UIAlertAction(
    title: "OK", style: UIAlertActionStyle.Default) {
        (action) -> Void in
            print("You entered \(((alertController.textFields?.first)! as UITextField).text)")
            self.email = ((alertController.textFields?.first)! as UITextField).text!
            NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "permName")
            self.label.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
    }
    let cancelAction = UIAlertAction(
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
    }
    override func viewDidAppear(animated: Bool) {
        
//        if ((NSUserDefaults.standardUserDefaults().objectForKey("permName")) == nil) {
//            let alertController = UIAlertController(
//                title: "Email",
//                message: "Please enter your Email",
//                preferredStyle: UIAlertControllerStyle.Alert )
//        
//            let okAction = UIAlertAction(
//                title: "OK", style: UIAlertActionStyle.Default) {
//                    (action) -> Void in
//                    print("You entered \(((alertController.textFields?.first)! as UITextField).text)")
//                    self.email = ((alertController.textFields?.first)! as UITextField).text!
//                    NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "permName")
//                    self.label.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
//            }
//            let cancelAction = UIAlertAction(
//                title: "Cancel", style: UIAlertActionStyle.Cancel) {
//                    (action) -> Void in      
//            }
//
//            alertController.addTextFieldWithConfigurationHandler {
//                (txtEmail) -> Void in
//                txtEmail.text = NSUserDefaults.standardUserDefaults().objectForKey("permName") as? String
//            }
//            alertController.addAction(cancelAction)
//            alertController.addAction(okAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
        
        
            self.email = ("Garrettogrady@gmail.com")
        var viewLoads = NSUserDefaults.standardUserDefaults().objectForKey("loadednumber") as? Bool
        if ((viewLoads) == nil){
            let directController = UIAlertController(
                title: "Welcome to the beaconator app!",
                message: "The beaconator app is used to track locations of users via BLE iBeacons. Since there was no practical way to display the true functionalities of the app, I have implemented test data and attached screenshots to show the code. When around iBeacons, CoreBluetooth begins monitoring for beacons and picks up the closest beacon and sends you a push notification that you have entered the region. It then sends that to the web-app, and the view pulls all the user's data from the web-app. If you have any more questions feel free to refer to the functionalities essay for more details... Thank you!",
                preferredStyle: UIAlertControllerStyle.Alert )
        
            let okAction = UIAlertAction(
                title: "OK", style: UIAlertActionStyle.Default) {
                    (action) -> Void in
           
            }
            let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.Cancel) {
                (action) -> Void in
            }
        
       
            directController.addAction(cancelAction)
            directController.addAction(okAction)
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "loadednumber")
            self.presentViewController(directController, animated: true, completion: nil)
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueTest") {
            let svc = segue.destinationViewController as! SecondViewController
            let path = self.tableView.indexPathForSelectedRow!.row
            print(path)
            svc.justLocation = repositories[path].description!
            svc.nameLabel = repositories[path].name!
            svc.locationLabel = repositories[path].description! 
            svc.time = repositories[path].time!
        }
        if segue.identifier == "seguePreview" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destinationViewController as! SecondViewController
                let path = self.tableView.indexPathForSelectedRow!.row
                print(path)
                controller.justLocation = repositories[path].description!
                controller.nameLabel = repositories[path].name!
                controller.locationLabel = repositories[path].description!
                controller.time = repositories[path].time!
            }
        }
        
    }
    func findExactTime(updatedTime:String) -> String {
        var postfixy = "am"
        let str = updatedTime
        let index = str.startIndex.advancedBy(11)
        str[index]
        let endIndex = str.endIndex.advancedBy(-8)
        var time = str[Range(start: index, end: endIndex)]
        
        func findMinute(minutes: String) -> String {
            let str = minutes
            let index = str.startIndex.advancedBy(3)
            str[index]
            let time =  str.substringFromIndex(index)
            return time
        }
        func findHour(hour: String) -> String {
            let str = hour
            let index = str.startIndex.advancedBy(0)
            str[index] // returns Character 'o'
            let endIndex = str.endIndex.advancedBy(-3)
            let time = str[Range(start: index, end: endIndex)]
            return time
        }
        let mins = findMinute(time)
        var postfix = "am"
        var hour = Int(findHour(time))!
        if (hour < 5) {
            hour = hour + 24
        }
        hour = hour - 4
        if (hour > 12) {
            postfix = "pm"
            hour = hour - 12
        }
        if (12 >= hour && hour >= 9 && postfix == "pm") {
            return "wrong date"
        }
        return " (since \(hour):\(mins) \(postfix))"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
//                let randomTime = Int(arc4random_uniform(59))
//                let randomLocation = Int(arc4random_uniform(3))
//                let name = listNames[indexPath.row]
//                cell.textLabel?.text = name
//                let timeUpdate = " \(randomTime) minutes ago"
        //        cell.detailTextLabel?.text = locations[randomLocation] + timeUpdate
        let name = repositories[indexPath.row].name
        print("Name is" + name!)
        let randomTime = repositories[indexPath.row].time!
        
        let timeUpdate = " \(randomTime) minutes ago"
        cell.detailTextLabel?.text = repositories[indexPath.row].description! + timeUpdate
        
        
//        let timeUpdate = findExactTime(repositories[indexPath.row].time!)
//        let description = repositories[indexPath.row].description
//        let detail = "\(description) (since \(timeUpdate)"
        cell.textLabel?.text = name
//        let formatter: NSDateFormatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateTimePrefix: String = formatter.stringFromDate(NSDate())
//        print(dateTimePrefix)
//        
//        if (repositories[indexPath.row].time!.rangeOfString(dateTimePrefix) != nil) && (detail.rangeOfString("wrong date") == nil) {
//            cell.detailTextLabel?.text = repositories[indexPath.row].description! + timeUpdate
//        }
//        else {
//            cell.detailTextLabel?.text = repositories[indexPath.row].description!
//        }
        if (cell.detailTextLabel?.text?.rangeOfString("away") != nil) {
            cell.contentView.backgroundColor = UIColor.lightGrayColor()
        }
        else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        let image : UIImage = UIImage(named: name!)!
        //print("The loaded image: \(image)")
        cell.imageView!.image = image
        //print(listNames[indexPath.row])

        //print(repositories[indexPath.row].image!)
//        let url = NSURL(string: "http://beaconator.fusionarydev.com/storage/\(repositories[indexPath.row].image!)")
//        let data = NSData(contentsOfURL: url!)
//        print(url)
//        cell.imageView!.image = UIImage(data: data!)
        
        
        return cell
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let alert = UIAlertView()
        alert.delegate = self
        alert.title = "Selected Row"
        alert.message = "You selected row \(indexPath.row)"
        alert.addButtonWithTitle("OK")
        alert.show()
        return NSIndexPath()
    }

}

extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        //pop

        
        if let secondVC = storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as? SecondViewController {
            secondVC.justLocation = secondJustLocation
            secondVC.nameLabel = secondNameLabel
            secondVC.locationLabel = secondLocationLabel
            secondVC.time = secondTime
            
            showViewController(secondVC, sender: self)
            refresh("")
        }
        
       

    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        //peek
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let secondVC = storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as? SecondViewController else { return nil }
        
        
        secondVC.justLocation = repositories[indexPath.row].description!
        secondVC.nameLabel = repositories[indexPath.row].name!
        secondVC.locationLabel = repositories[indexPath.row].description!
        secondVC.time = repositories[indexPath.row].time!
        
        secondTime = repositories[indexPath.row].time!
        secondLocationLabel = repositories[indexPath.row].description!
        secondNameLabel = repositories[indexPath.row].name!
        secondJustLocation = repositories[indexPath.row].description!

        previewingContext.sourceRect = cell.frame
        return secondVC
    }
}

