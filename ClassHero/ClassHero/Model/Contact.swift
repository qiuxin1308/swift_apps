//
//  User.swift
//  ClassHero
//
//  Created by ouyang chenxing on 02/19/18.
//  Copyright © 2018 CSE437. All rights reserved.

import UIKit

class Contact: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var score: Int?
    var classTag: [String: Bool]?
    var avatarURL: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.avatarURL = dictionary["avatarURL"] as? String
        self.score = dictionary["score"] as? Int
        self.classTag = dictionary["classTag"] as? [String: Bool]
    }
}
