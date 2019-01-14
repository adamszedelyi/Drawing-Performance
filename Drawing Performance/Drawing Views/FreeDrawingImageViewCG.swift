//
//  FreeDrawingImageView.swift
//
//  Created by Besher on 2018-12-30.
//  Copyright © 2018 Besher Al Maleh. All rights reserved.
//

import UIKit

// Slow CPU
class FreedrawingImageViewCG: FreedrawingImageView {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        guard let previousTouchPoint = currentTouchPosition else { return }
        stopAutoDrawing()
        slowDraw(from: previousTouchPoint, to: newTouchPoint)
        
        currentTouchPosition = newTouchPoint
    }
    
    func slowDraw(from start: CGPoint, to end: CGPoint) {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        image = renderer.image { ctx in
            image?.draw(in: bounds)
            
            lineColor.setStroke()
            
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(lineWidth)
            ctx.cgContext.move(to: start)
            ctx.cgContext.addLine(to: end)
            ctx.cgContext.strokePath()
        }
    }
    
    override func drawSpiral() {
        let link = CADisplayLink(target: self, selector: #selector(drawSpiralLink))
        link.add(to: .main, forMode: .default)
        displayLink = link
    }
    
    @objc override func drawSpiralLink() {
        if self.spiralPoints.isEmpty {
            self.createSpiral()
            self.currentTouchPosition = nil
        } else {
            let previousPoint = self.currentTouchPosition ?? self.spiralPoints.removeFirst()
            let newPoint = self.spiralPoints.removeFirst()
            
            self.slowDraw(from: previousPoint, to: newPoint)
            
            self.currentTouchPosition = newPoint
        }
    }
    
    override func clear() {
        clearSublayers()
        spiralPoints.removeAll()
        image = nil 
    }
}
