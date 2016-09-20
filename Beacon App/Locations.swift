//
//  Repository.swift
//  TableTutorial
//
//   Created by Garrett O'Grady on 😏.
//  Copyright (c) 2015 Fusionary. 👀 :All rights reserved.
//


// function to parse json data used in thirdviewcontroller



import UIKit

class Locations {
    
    var name: String?
    var description: String?
    var image: String?
    var time: String?
    
    init(json: NSDictionary) {
        self.name = json["email"] as? String
        self.description = json["user"] as? String
        self.time = json["created"] as? String
        //self.image = json["image"] as? String
    }
    
}