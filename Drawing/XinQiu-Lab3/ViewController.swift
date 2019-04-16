//
//  ViewController.swift
//  XinQiu-Lab3
//
//  Created by Xin Qiu on 9/30/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentPathPoint = CGPoint.zero
    var currentPath: drawLine?
    var drawPathCanvas: drawLineView!
    var currenWidth: drawLine!
    var currentColor: UIColor?
    var removePath: drawLine?
    var removePathsArray: Array<drawLine> = Array()
    
    
    @IBOutlet weak var sliderValueForBrush: UISlider!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var sliderValueForAlpha: UISlider!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var redoButton: UIButton!
    
    
    @IBAction func clearScreen(_ sender: Any) {
        drawPathCanvas.thePath = nil
        drawPathCanvas.paths = []
        removePathsArray.removeAll()
    }
    
    @IBAction func backToTheLastPath(_ sender: Any) {
        
        let isPathCount = drawPathCanvas.paths.count
        
        if (drawPathCanvas.thePath != nil) {
            drawPathCanvas.thePath = nil
        }
        
        if (isPathCount > 0) {
            undoButton.isEnabled = true
            removePath = drawPathCanvas.paths[isPathCount-1]
            drawPathCanvas.paths.removeLast()
            removePathsArray.append(removePath!)
            redoButton.isEnabled = true
            
        }else if (isPathCount == 0){
            undoButton.isEnabled = false
        }
    }
    
    @IBAction func redoThePath(_ sender: Any) {
        
        let arrayCount = removePathsArray.count
        
            if (arrayCount != 0) {
                redoButton.isEnabled = true
                drawPathCanvas.paths.append(removePathsArray[arrayCount-1])
                removePathsArray.removeLast()
                view.addSubview(drawPathCanvas)
                view.addSubview(redButton)
                view.addSubview(orangeButton)
                view.addSubview(yellowButton)
                view.addSubview(greenButton)
                view.addSubview(blueButton)
                view.addSubview(purpleButton)
                view.addSubview(opacityLabel)
                view.addSubview(sliderValueForAlpha)
                undoButton.isEnabled = true
            }else{
                redoButton.isEnabled = false
            }
    }
    
    
    @IBAction func changeToRed(_ sender: UIButton) {
        currentColor = redButton.backgroundColor
    }
    
    @IBAction func changeToOrange(_ sender: UIButton) {
        currentColor = orangeButton.backgroundColor
    }
    
    @IBAction func changeToYellow(_ sender: UIButton) {
        currentColor = yellowButton.backgroundColor
    }
    
    @IBAction func changeToGreen(_ sender: UIButton) {
        currentColor = greenButton.backgroundColor
    }
    
    @IBAction func changeToBlue(_ sender: UIButton) {
        currentColor = blueButton.backgroundColor
    }
    
    @IBAction func changeToPurple(_ sender: UIButton) {
        currentColor = purpleButton.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawPathCanvas = drawLineView(frame: self.view.frame)
        view.addSubview(drawPathCanvas)
        view.addSubview(redButton)
        view.addSubview(orangeButton)
        view.addSubview(yellowButton)
        view.addSubview(greenButton)
        view.addSubview(blueButton)
        view.addSubview(purpleButton)
        view.addSubview(opacityLabel)
        view.addSubview(sliderValueForAlpha)
        redButton.layer.cornerRadius = redButton.layer.frame.width/2
        orangeButton.layer.cornerRadius = orangeButton.layer.frame.width/2
        yellowButton.layer.cornerRadius = yellowButton.layer.frame.width/2
        greenButton.layer.cornerRadius = greenButton.layer.frame.width/2
        blueButton.layer.cornerRadius = blueButton.layer.frame.width/2
        purpleButton.layer.cornerRadius = purpleButton.layer.frame.width/2
        currentColor = redButton.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchPoint = touches.first?.location(in: view) else { return }
        
        let pathWidth = CGFloat(sliderValueForBrush.value)
        let pathOpacity = CGFloat(sliderValueForAlpha.value)
        
        currentPath = drawLine(path: [touchPoint], width: pathWidth, pathColor: currentColor!,alpha: pathOpacity)
        undoButton.isEnabled = true
        redoButton.isEnabled = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: view)
        
        currentPath?.path.append(touchPoint!)
        drawPathCanvas.thePath = currentPath

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let newPath = currentPath {
            drawPathCanvas.paths.append(newPath)
        }
    }
}

