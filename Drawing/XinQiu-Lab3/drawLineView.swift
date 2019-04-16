//
//  drawLineView.swift
//  XinQiu-Lab3
//
//  Created by Xin Qiu on 9/30/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit

class drawLineView: UIView {
    
    var thePath: drawLine? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var paths:[drawLine] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        for drawPaths in paths {
            drawPath(drawPaths)
        }
        if (thePath != nil) {
            drawPath(thePath!)
        }
    }
    
    func drawPath(_ pathToDraw: drawLine){
        
        var line: UIBezierPath
        //UIColor.purple.setStroke()
        let color: UIColor = pathToDraw.pathColor
        let alpha = pathToDraw.alpha
        line = createQuadPath(points: pathToDraw.path)
        line.lineWidth = pathToDraw.width
        color.setStroke()
        line.stroke(with: .normal, alpha: alpha)
        
        let firstDot = createDot(point: pathToDraw.path[0], radius: pathToDraw.width / 2)
        //UIColor.purple.setFill()
        color.setFill()
        firstDot.fill(with: .normal, alpha: alpha)
        
    }
    
    private func midPoint(first:CGPoint,second:CGPoint) -> CGPoint {
        return CGPoint(x: (first.x + second.x)/2, y: (first.y + second.y)/2)
    }
    
    func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 {
            return path
        }
        
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidPoint = midPoint(first: firstPoint, second: secondPoint)
        
        path.move(to: firstPoint)
        path.addLine(to: firstMidPoint)
        for index in 1..<points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = self.midPoint(first: currentPoint, second: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
    
    func createDot(point: CGPoint,radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: point, radius: radius, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        return path
    }
}
