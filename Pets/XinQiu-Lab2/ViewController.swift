//
//  ViewController.swift
//  XinQiu-Lab2
//
//  Created by Xin Qiu on 9/17/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var happinessView: DisplayView!
    @IBOutlet weak var foodView: DisplayView!
    @IBOutlet weak var displayHappiness: UILabel!
    @IBOutlet weak var displayFood: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var birdButton: UIButton!
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var bunnyButton: UIButton!
    @IBOutlet weak var fishButton: UIButton!
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    private var dogInstance: Pet!
    private var birdInstance: Pet!
    private var catInstance: Pet!
    private var bunnyInstance: Pet!
    private var fishInstance: Pet!
    private var petType = ""
    
    @IBAction private func toPlay(_ sender: Any) {
        switch petType {
         case "dog":
            dogInstance.play()
            selectDog()
         case "bird":
            birdInstance.play()
            selectBird()
         case "cat":
            catInstance.play()
            selectCat()
         case "fish":
            fishInstance.play()
            selectFish()
         case "bunny":
            bunnyInstance.play()
            selectBunny()
        default:
            print("null")
        }
    }
    
    @IBAction private func toFeed(_ sender: Any) {
        switch petType {
        case "dog":
            dogInstance.feed()
            selectDog()
        case "bird":
            birdInstance.feed()
            selectBird()
        case "cat":
            catInstance.feed()
            selectCat()
        case "fish":
            fishInstance.feed()
            selectFish()
        case "bunny":
            bunnyInstance.feed()
            selectBunny()
        default:
            print("null")
        }
    }
    
    @IBAction func dogSelected(_ sender: Any) {
        dogButton.setTitleColor(UIColor.black, for: .normal)
        dogButton.backgroundColor = UIColor.lightGray
        catButton.setTitleColor(UIColor.blue, for: .normal)
        catButton.backgroundColor = UIColor.white
        birdButton.setTitleColor(UIColor.blue, for: .normal)
        birdButton.backgroundColor = UIColor.white
        bunnyButton.setTitleColor(UIColor.blue, for: .normal)
        bunnyButton.backgroundColor = UIColor.white
        fishButton.setTitleColor(UIColor.blue, for: .normal)
        fishButton.backgroundColor = UIColor.white
        happinessView.value = CGFloat(Double(dogInstance.happinessRate)/100)
        foodView.value = CGFloat(Double(dogInstance.feedRate)/100)

        selectDog()
    }
    
    @IBAction func birdSelected(_ sender: Any) {
        birdButton.setTitleColor(UIColor.black, for: .normal)
        birdButton.backgroundColor = UIColor.lightGray
        dogButton.setTitleColor(UIColor.blue, for: .normal)
        dogButton.backgroundColor = UIColor.white
        catButton.setTitleColor(UIColor.blue, for: .normal)
        catButton.backgroundColor = UIColor.white
        bunnyButton.setTitleColor(UIColor.blue, for: .normal)
        bunnyButton.backgroundColor = UIColor.white
        fishButton.setTitleColor(UIColor.blue, for: .normal)
        fishButton.backgroundColor = UIColor.white
        happinessView.value = CGFloat(Double(birdInstance.happinessRate)/100)
        foodView.value = CGFloat(Double(birdInstance.feedRate)/100)
        
        selectBird()
    }
    
    @IBAction func catSelected(_ sender: Any) {
        catButton.setTitleColor(UIColor.black, for: .normal)
        catButton.backgroundColor = UIColor.lightGray
        dogButton.setTitleColor(UIColor.blue, for: .normal)
        dogButton.backgroundColor = UIColor.white
        birdButton.setTitleColor(UIColor.blue, for: .normal)
        birdButton.backgroundColor = UIColor.white
        bunnyButton.setTitleColor(UIColor.blue, for: .normal)
        bunnyButton.backgroundColor = UIColor.white
        fishButton.setTitleColor(UIColor.blue, for: .normal)
        fishButton.backgroundColor = UIColor.white
        happinessView.value = CGFloat(Double(catInstance.happinessRate)/100)
        foodView.value = CGFloat(Double(catInstance.feedRate)/100)
        
        selectCat()
    }
    
    @IBAction func bunnySelected(_ sender: Any) {
        bunnyButton.setTitleColor(UIColor.black, for: .normal)
        bunnyButton.backgroundColor = UIColor.lightGray
        dogButton.setTitleColor(UIColor.blue, for: .normal)
        dogButton.backgroundColor = UIColor.white
        catButton.setTitleColor(UIColor.blue, for: .normal)
        catButton.backgroundColor = UIColor.white
        birdButton.setTitleColor(UIColor.blue, for: .normal)
        birdButton.backgroundColor = UIColor.white
        fishButton.setTitleColor(UIColor.blue, for: .normal)
        fishButton.backgroundColor = UIColor.white
        happinessView.value = CGFloat(Double(bunnyInstance.happinessRate)/100)
        foodView.value = CGFloat(Double(bunnyInstance.feedRate)/100)
        
        selectBunny()
    }
    
    @IBAction func fishSelected(_ sender: Any) {
        fishButton.setTitleColor(UIColor.black, for: .normal)
        fishButton.backgroundColor = UIColor.lightGray
        dogButton.setTitleColor(UIColor.blue, for: .normal)
        dogButton.backgroundColor = UIColor.white
        catButton.setTitleColor(UIColor.blue, for: .normal)
        catButton.backgroundColor = UIColor.white
        bunnyButton.setTitleColor(UIColor.blue, for: .normal)
        bunnyButton.backgroundColor = UIColor.white
        birdButton.setTitleColor(UIColor.blue, for: .normal)
        birdButton.backgroundColor = UIColor.white
        happinessView.value = CGFloat(Double(fishInstance.happinessRate)/100)
        foodView.value = CGFloat(Double(fishInstance.feedRate)/100)
        
        selectFish()
    }
    
    private func updateDog(){
        
        displayHappiness.text = "Played:  " + String(dogInstance.happinessRate)
        let displayHappinessValue = Double(dogInstance.happinessRate)/100
        
        displayFood.text = "fed:  " + String(dogInstance.feedRate)
        let displayFoodValue = Double(dogInstance.feedRate)/100
        
        
        if displayFoodValue > 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.isEnabled = true
            feedButton.setTitle("Feed", for: .normal)
            feedButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }else if displayFoodValue == 0 || displayFoodValue == 100 {
            
            happinessView.color = UIColor.lightGray
            foodView.value = CGFloat(Double(dogInstance.feedRate)/100)
            displayHappiness.text = "Dead"
            displayFood.text = "Dead"
            backgroundView.backgroundColor = UIColor.lightGray
            feedButton.setTitle("Revive", for: .normal)
            feedButton.backgroundColor = UIColor(red: 236/255,green: 93/255, blue:87/255, alpha:1.0)
            playButton.isEnabled = false
            
        }
        if displayHappinessValue == 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Just Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 236/255,green: 93/255, blue:87/255, alpha:1.0)
            
        }else if displayHappinessValue > 0{
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }
    }
    
    private func updateBird(){
        
        displayHappiness.text = "Played:  " + String(birdInstance.happinessRate)
        let displayHappinessValue = Double(birdInstance.happinessRate)/100
        
        displayFood.text = "fed:  " + String(birdInstance.feedRate)
        let displayFoodValue = Double(birdInstance.feedRate)/100
        
        
        if displayFoodValue > 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.isEnabled = true
            feedButton.setTitle("Feed", for: .normal)
            feedButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }else if displayFoodValue == 0 || displayFoodValue == 100 {
            
            happinessView.color = UIColor.lightGray
            foodView.value = CGFloat(Double(birdInstance.feedRate)/100)
            displayHappiness.text = "Dead"
            displayFood.text = "Dead"
            backgroundView.backgroundColor = UIColor.lightGray
            feedButton.setTitle("Revive", for: .normal)
            feedButton.backgroundColor = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
            playButton.isEnabled = false
        }
        
        if displayHappinessValue == 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Just Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
            
        }else if displayHappinessValue > 0{
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }
        
    }
    
    private func updateCat(){
        
        displayHappiness.text = "Played:  " + String(catInstance.happinessRate)
        let displayHappinessValue = Double(catInstance.happinessRate)/100
        
        displayFood.text = "fed:  " + String(catInstance.feedRate)
        let displayFoodValue = Double(catInstance.feedRate)/100
        
        
        if displayFoodValue > 0 {
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.isEnabled = true
            feedButton.setTitle("Feed", for: .normal)
            feedButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
        }else if displayFoodValue == 0 || displayFoodValue == 100 {
            happinessView.color = UIColor.lightGray
            foodView.value = CGFloat(Double(catInstance.feedRate)/100)
            displayHappiness.text = "Dead"
            displayFood.text = "Dead"
            backgroundView.backgroundColor = UIColor.lightGray
            feedButton.setTitle("Revive", for: .normal)
            feedButton.backgroundColor = UIColor(red: 91/255,green: 142/255, blue:242/255, alpha:1.0)
            playButton.isEnabled = false
        }
        if displayHappinessValue == 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Just Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 91/255,green: 142/255, blue:242/255, alpha:1.0)
            
        }else if displayHappinessValue > 0{
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }
        
        //displayHappiness.text = "Played:  " + String(catInstance.happinessRate)
        //let displayHappinessValue = Double(catInstance.happinessRate)/100
        //happinessView.animateValue(to: CGFloat(displayHappinessValue))
        
        //displayFood.text = "fed:  " + String(catInstance.feedRate)
        //let displayFoodValue = Double(catInstance.feedRate)/100
        //foodView.animateValue(to: CGFloat(displayFoodValue))
    }
    
    private func updateFish(){
        
        displayHappiness.text = "Played:  " + String(fishInstance.happinessRate)
        let displayHappinessValue = Double(fishInstance.happinessRate)/100
        
        displayFood.text = "fed:  " + String(fishInstance.feedRate)
        let displayFoodValue = Double(fishInstance.feedRate)/100
        
        
        if displayFoodValue > 0 {
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.isEnabled = true
            feedButton.setTitle("Feed", for: .normal)
            feedButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
        }else if displayFoodValue == 0 || displayFoodValue == 100 {
            happinessView.color = UIColor.lightGray
            foodView.value = CGFloat(Double(fishInstance.feedRate)/100)
            displayHappiness.text = "Dead"
            displayFood.text = "Dead"
            backgroundView.backgroundColor = UIColor.lightGray
            feedButton.setTitle("Revive", for: .normal)
            feedButton.backgroundColor = UIColor(red: 220/255,green: 161/255, blue:249/255, alpha:1.0)
            playButton.isEnabled = false
        }
        if displayHappinessValue == 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Just Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 220/255,green: 161/255, blue:249/255, alpha:1.0)
            
        }else if displayHappinessValue > 0{
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }
    }
    
    private func updateBunny(){
        
        displayHappiness.text = "Played:  " + String(bunnyInstance.happinessRate)
        let displayHappinessValue = Double(bunnyInstance.happinessRate)/100
        
        displayFood.text = "fed:  " + String(bunnyInstance.feedRate)
        let displayFoodValue = Double(bunnyInstance.feedRate)/100
        
        
        if displayFoodValue > 0 {
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.isEnabled = true
            feedButton.setTitle("Feed", for: .normal)
            feedButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
        }else if displayFoodValue == 0 || displayFoodValue == 100 {
            happinessView.color = UIColor.lightGray
            foodView.value = CGFloat(Double(bunnyInstance.feedRate)/100)
            displayHappiness.text = "Dead"
            displayFood.text = "Dead"
            backgroundView.backgroundColor = UIColor.lightGray
            feedButton.setTitle("Revive", for: .normal)
            feedButton.backgroundColor = UIColor(red: 255/255,green: 111/255, blue:207/255, alpha:1.0)
            playButton.isEnabled = false
        }
        if displayHappinessValue == 0 {
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Just Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 255/255,green: 111/255, blue:207/255, alpha:1.0)
            
        }else if displayHappinessValue > 0{
            
            happinessView.animateValue(to: CGFloat(displayHappinessValue))
            foodView.animateValue(to: CGFloat(displayFoodValue))
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor(red: 204/255,green: 204/255, blue:204/255, alpha:1.0)
            
        }
    }
    
    private func selectBird(){
        petType = "bird"
        petImage.image = UIImage(named:"bird")
        backgroundView.backgroundColor = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
        happinessView.color = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
        foodView.color = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
        
        updateBird()
        
    }
    
    private func selectDog(){
        petType = "dog"
        petImage.image = UIImage(named:"dog")
        backgroundView.backgroundColor = UIColor(red: 236/255,green: 93/255, blue:87/255, alpha:1.0)
        happinessView.color = UIColor(red: 236/255,green: 93/255, blue:87/255, alpha:1.0)
        foodView.color = UIColor(red: 236/255,green: 93/255, blue:87/255, alpha:1.0)
        
        updateDog()
    }
    
    private func selectCat(){
        petType = "cat"
        petImage.image = UIImage(named:"cat")
        backgroundView.backgroundColor = UIColor(red: 91/255,green: 142/255, blue:242/255, alpha:1.0)
        happinessView.color = UIColor(red: 91/255,green: 142/255, blue:242/255, alpha:1.0)
        foodView.color = UIColor(red: 91/255,green: 142/255, blue:242/255, alpha:1.0)
        
        updateCat()
    }
    
    private func selectBunny(){
        petType = "bunny"
        petImage.image = UIImage(named:"bunny")
        backgroundView.backgroundColor = UIColor(red: 255/255,green: 111/255, blue:207/255, alpha:1.0)
        happinessView.color = UIColor(red: 255/255,green: 111/255, blue:207/255, alpha:1.0)
        foodView.color = UIColor(red: 255/255,green: 111/255, blue:207/255, alpha:1.0)
        
        updateBunny()
    }
    
    private func selectFish(){
        petType = "fish"
        petImage.image = UIImage(named:"fish")
        backgroundView.backgroundColor = UIColor(red: 220/255,green: 161/255, blue:249/255, alpha:1.0)
        happinessView.color = UIColor(red: 220/255,green: 161/255, blue:249/255, alpha:1.0)
        foodView.color = UIColor(red: 220/255,green: 161/255, blue:249/255, alpha:1.0)
        
        updateFish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        birdInstance = Pet(name:"bird",type:.bird)
        dogInstance = Pet(name:"dog",type:.dog)
        catInstance = Pet(name:"cat",type:.cat)
        fishInstance = Pet(name:"fish",type:.fish)
        bunnyInstance = Pet(name:"bunny",type:.bunny)
        
        petImage.image = UIImage(named:"bird")
        backgroundView.backgroundColor = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
        happinessView.color = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
        foodView.color = UIColor(red: 248/255,green: 213/255, blue:108/255, alpha:1.0)
        selectBird()
        birdButton.setTitleColor(UIColor.black, for: .normal)
        birdButton.backgroundColor = UIColor.lightGray
        dogButton.setTitleColor(UIColor.blue, for: .normal)
        dogButton.backgroundColor = UIColor.white
        catButton.setTitleColor(UIColor.blue, for: .normal)
        catButton.backgroundColor = UIColor.white
        bunnyButton.setTitleColor(UIColor.blue, for: .normal)
        bunnyButton.backgroundColor = UIColor.white
        fishButton.setTitleColor(UIColor.blue, for: .normal)
        fishButton.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

