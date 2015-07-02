//
//  Repository.swift
//  TableTutorial
//
//  Created by Garrett O'Grady on 6/10/15.
//  Copyright (c) 2015 Garrett O'Grady. All rights reserved.
//

import UIKit

class Repository {
    
    var name: String?
    var description: String?
    var image: String?
    
    init(json: NSDictionary) {
        self.name = json["fname"] as? String
        self.description = json["location"] as? String
        //self.image = json["image"] as? String
    }
}