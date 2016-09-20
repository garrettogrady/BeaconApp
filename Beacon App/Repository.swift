//
//  Repository.swift
//  TableTutorial
//
//   Created by Garrett O'Grady on 😏.
//  Copyright (c) 2015 Fusionary. 👀 :All rights reserved.


// function for parse json data used in viewcontroller 

import UIKit

class Repository {
    
    var name: String?
    var description: String?
    var image: String?
    var time: String?
    
    init(json: NSDictionary) {
        self.name = json["fname"] as? String
        self.description = json["beaconName"] as? String
        self.time = json["locationUpdated"] as? String
        self.image = json["avatar"] as? String
    }
    
}