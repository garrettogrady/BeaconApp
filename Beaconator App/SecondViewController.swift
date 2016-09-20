//
//  TableViewController.swift
//  iBeaconTemplateSwift
//
//  Created by Garrett O'Grady on 7/15/15.
//  Copyright (c) 2015 iBeaconModules.us. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var location: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var Label: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var previousActivityLabel: UILabel!
    
    @IBOutlet var arrivedAt: UILabel!
    var nameLabel = String()
    var users = [Users]()
    var repositorys = [Repository]()
    var locationLabel = String()
    var justLocation = String()
    var time = String()
    var locations = ["Conference Room", "Bryan's Office", "Workspace", "Arrived"]
    var times = ["2:03 pm", "11:40 am", "9:05 am", "7:40 am"]
    var thirdNameLabel = ""
    var thirdLocationLabel = ""
    var thirdTime = ""
    
    var timeEntered = 0
    @IBOutlet var date: UILabel!
    
    @IBOutlet var avatar0: UIImageView!
    @IBOutlet var avatar1: UIImageView!
    @IBOutlet var avatar2: UIImageView!
    @IBOutlet var avatar3: UIImageView!
    @IBOutlet var avatar4: UIImageView!
    
    @IBOutlet var avatars: [UIImageView]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       print("SECOND VIEW LOADING")
        recieveEvent()
        let nameAry = ["Rob","Roger","Godwin","Casey","Andrew"]
        let i = Int(arc4random_uniform(4))
        avatar0.image = UIImage(named: nameAry[i])
        
        avatar.image = UIImage(named: "noimg.png")
        avatar.hidden = false
        recieveOtherEvent()
        let theDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Hour, .Minute, .Second], fromDate: theDate)
        let mins = components.minute
        var realMins = mins - Int(time)!
        if (realMins < 0) {
            realMins = realMins * -1
        }
        if (realMins < 10) {
            realMins += 10
        }
        location.text = locationLabel + " (since 2:\(realMins) pm)"
        Label.text = nameLabel
        var pictureNumber = 0
        print("printing avatars count\(avatars.count)")
        print("counting respositories")
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateTimePrefix: String = formatter.stringFromDate(NSDate())
        
        var found = 0
        //checks if the days match up the same
        if (time.rangeOfString(dateTimePrefix) != nil)  {
            for var index = 0; index < repositorys.count && pictureNumber < avatars.count; index++ {
                print("looping")
                var avatarpic = avatars
                if (repositorys[index].description! == justLocation && repositorys[index].name! != nameLabel && repositorys[index].time!.rangeOfString(dateTimePrefix) != nil) {
                    print("time is \(repositorys[index].time!)")
                    print("date is \(dateTimePrefix)")
                    print("person is \(repositorys[index].name!)")
                    let urlName = repositorys[index].name! + ".png"
                    
                    let url = NSURL(string: "http://beaconator.fusionarydev.com/storage/\(urlName)")!
                    print(url)
                    let data = NSData(contentsOfURL: url)
                    avatars[pictureNumber].image = UIImage(data: data!)
                    pictureNumber++
                }
                else {
                    print("passing if statemet")
                }
            }
            
         }

        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        date.text = timestamp
        let url = NSURL(string: "http://beaconator.fusionarydev.com/storage/\(nameLabel).png")!
        let data = NSData(contentsOfURL: url)
        
        avatar.image = UIImage(named: nameLabel)!
        //print("yoyoyoyo")
        //print("http://beaconator.fusionarydev.com/storage/\(nameLabel).png")
        previousActivityLabel.text = "\(nameLabel)'s Previous Activity"
        previousActivityLabel.layer.cornerRadius = 5
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(hue: 0.5167, saturation: 0.4, brightness: 0.99, alpha: 1.0).CGColor
        // Do any additional setup after loading the view.
       registerForPreviewingWithDelegate(self, sourceView: tableView)
    }
    //function to find the time
    
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
            str[index]
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
        if (12 > hour && hour > 9 && postfix == "pm") {
            postfix = "wrong date"
        }
        return " (at \(hour):\(mins) \(postfix))"
    }
    func recieveOtherEvent() {
        let reposURL = NSURL(string: "http://beaconator.fusionarydev.com/api/user")
        // 2
        print("step 2")
        if let JSONData = NSData(contentsOfURL: reposURL!) {
            // 3
            print("step 3")
            if let json = (try? NSJSONSerialization.JSONObjectWithData(JSONData, options: [])) as? NSDictionary {
                // 4
                print("step 4")
                if let reposArray = json["items"] as? [NSDictionary] {
                    // 5
                    for item in reposArray {
                        repositorys.append(Repository(json: item))
                    }
                }
            }
        }
    }
    // function to parse the data from the api
    func recieveEvent() {
        let reposURL = NSURL(string: "http://beaconator.fusionarydev.com/api/event?user.fname=\(nameLabel)")
        print("step 2")
        if let JSONData = NSData(contentsOfURL: reposURL!) {
            print("step 3")
            if let json = (try? NSJSONSerialization.JSONObjectWithData(JSONData, options: [])) as? NSDictionary {
                print("step 4")
                if let reposArray = json["items"] as? [NSDictionary] {
                    for item in reposArray {
                        users.append(Users(json: item))
                    }
                    print("event sucessfully recieved")
                }
            }
        }
    }
    // function for counting number of rows.. it is based on the current day
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return locations.count
    }
    //function to populate the table with data that has been parsed
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath)
        
        var location = locations[indexPath.row]
        var arrivedTime = times[indexPath.row]
        
        cell1.detailTextLabel?.text = arrivedTime
        cell1.textLabel?.text = location

        return cell1
    }
    // segue function to set variables in thirdviewcontroller to variables in the secondviewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Locations") {
            let svc = segue.destinationViewController as! ThirdViewController //sets svc to thirdviewcontroller
    
            let path = self.tableView.indexPathForSelectedRow!.row
            svc.nameLabel = nameLabel
            svc.locationLabel = locations[path]
            svc.time = time
        }
        if segue.identifier == "firstBack" {
            let fvc = segue.destinationViewController as! ViewController
            //fvc.viewDidLoad()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SecondViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        //pop
        
        
        if let thirdVC = storyboard?.instantiateViewControllerWithIdentifier("ThirdViewController") as? ThirdViewController {
            thirdVC.nameLabel = thirdNameLabel
            thirdVC.locationLabel = thirdLocationLabel
            thirdVC.time = thirdTime
            
            showViewController(thirdVC, sender: self)
        }
        
        
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        //peek
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let thirdVC = storyboard?.instantiateViewControllerWithIdentifier("ThirdViewController") as? ThirdViewController else { return nil }
        
        
        thirdVC.nameLabel = nameLabel
        thirdVC.locationLabel = locations[indexPath.row]
        thirdVC.time = time
        
        thirdTime = thirdVC.nameLabel
        thirdLocationLabel = thirdVC.locationLabel
        thirdNameLabel = thirdVC.time
        
        previewingContext.sourceRect = cell.frame
        return thirdVC
    }
}