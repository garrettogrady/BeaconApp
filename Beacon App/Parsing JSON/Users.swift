//
//  Repository.swift
//  TableTutorial
//
//   Created by Garrett O'Grady on 😏.
//  Copyright (c) 2015 Fusionary. 👀 :All rights reserved.
//



// function for parse json data used in secondary viewcontroller



import UIKit

class Users {
    
    var name: String?
    var description: String?
    var image: String?
    var time: String?
    var location: String?
    
    init(json: NSDictionary) {
        self.name = json["eventAction"] as? String
        self.description = json["beaconName"] as? String
        self.time = json["created"] as? String
        self.location = json["beaconName"] as? String
        
        //self.image = json["image"] as? String
    }
    
}