//
//  ThirdViewController.swift
//  iBeaconTemplateSwift
//
//  Created by Garrett O'Grady on 7/29/15.
//  Copyright (c) 2015 iBeaconModules.us. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //outlets connecting storyboard items to variables
    @IBOutlet var officeImage: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var avatar0: UIImageView!
    @IBOutlet var avatar1: UIImageView!
    @IBOutlet var avatar2: UIImageView!
    @IBOutlet var avatar3: UIImageView!
    @IBOutlet var avatar4: UIImageView!
    @IBOutlet var avatar5: UIImageView!
    @IBOutlet var avatars: [UIImageView]!
    
    //setting variables to files
    var repositorys = [Repository]()
    var locations = [Locations]()
    var names = ["Bryan", "Steve", "Jack"]
    var times = ["(arrived at 4:13 pm)", "(arrived at 4:12 pm)", "(arrived at 4:10 pm)"]

    
    // variables that are being set in the second viewcontroller
    var nameLabel = String()
    var locationLabel = String()
    var time = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recieveEvent()
        recieveOtherEvent()
        //officeImage.image = UIImage(named: locationLabel + ".png")
        location.text = locationLabel
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        // Do any additional setup after loading the view.
        var found = 0
        print("pringing repos count")
        print(repositorys.count)
        print(avatars)
        var pictureNumber = 0
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateTimePrefix: String = formatter.stringFromDate(NSDate())
        //checks if the days match up the same 
        if (time.rangeOfString(dateTimePrefix) != nil)  {
            for var index = 0; index < repositorys.count && pictureNumber < avatars.count; index++ {
            var avatarpic = avatars
                if (repositorys[index].description! == locationLabel && repositorys[index].time!.rangeOfString(dateTimePrefix) != nil) {
                    let urlName = repositorys[index].name! + ".png"
                    let url = NSURL(string: "http://beaconator.fusionarydev.com/storage/\(urlName)")!
                    print(url)
                    let data = NSData(contentsOfURL: url)
                    avatars[pictureNumber].image = UIImage(data: data!)
            
                    pictureNumber++
                }
            }
        }
    }
    
    // function to find the exact time
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
    
    //function for parsing the data form the api
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
    
    func recieveEvent() {
        
        var locationName = locationLabel
        let myString = locationLabel as String
        locationName = locationName.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print(locationName)
        let reposURL = NSURL(string: "http://beaconator.fusionarydev.com/api/event?beaconName=\(locationName)")
        print("step 2")
        if let JSONData = NSData(contentsOfURL: reposURL!) {
            print("step 3")
            if let json = (try? NSJSONSerialization.JSONObjectWithData(JSONData, options: [])) as? NSDictionary {
                print("step 4")
                if let reposArray = json["items"] as? [NSDictionary] {
                    for item in reposArray {
                        locations.append(Locations(json: item))
                    }
                    print("sucesfully recived event")
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell3", forIndexPath: indexPath) 
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = times[indexPath.row]
        
        return cell
    }

}
