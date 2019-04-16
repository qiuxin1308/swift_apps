//
//  Pets.swift
//  XinQiu-Lab2
//
//  Created by Xin Qiu on 9/17/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import Foundation

class Pet {
    
    enum petsType {
        
        case bird
        case dog
        case fish
        case bunny
        case cat
        
    }
    
    //Data
    private (set) var happinessRate: Int
    private (set) var feedRate: Int
    private var name: String
    private var typeOfPets: petsType
    
    func play(){
        
        if (feedRate > 0 && happinessRate != 100) {
            happinessRate += 10
            feedRate -= 12
            if (happinessRate > 100) {
                happinessRate = 100
            }
            if (feedRate < 0) {
                feedRate = 0
            }
        }
    }
    
    func feed(){
        
        if (happinessRate > 0) {
            feedRate += 8
            if (feedRate > 50 && feedRate < 100) {
                happinessRate -= 12
            }
            if (feedRate > 100) {
                feedRate = 100
            }
            if (happinessRate < 0) {
                happinessRate = 0
            }
        }
        
    }
    
    
    //Init
    
    init(name: String, type:petsType) {
        self.name = name
        self.typeOfPets = type
        happinessRate = 10
        feedRate = 20
    }
}
