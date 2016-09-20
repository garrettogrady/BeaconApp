//
//  FifthViewController.swift
//  iBeaconTemplateSwift
//
//  Created by Garrett O'Grady on 4/25/16.
//  Copyright © 2016 iBeaconModules.us. All rights reserved.
//

import UIKit


class FifthViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var names = ["Jack", "Garrett"]
    var times = ["(since 16 minutes ago)", "(since 17 minutes ago)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = times[indexPath.row]
        
        return cell
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
