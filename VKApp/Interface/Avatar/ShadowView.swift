//
//  ShadowView.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 04.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: rect.midX - shadowCircleRadius, y: rect.midY - shadowCircleRadius, width: shadowCircleRadius * 2, height: shadowCircleRadius * 2)).cgPath
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.updateShadowColor()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1 {
        didSet {
            self.updateShadowOpacity()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 8 {
        didSet {
            self.updateShadowRadius()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            self.updateShadowOffset()
        }
    }
    
    @IBInspectable var shadowCircleRadius: CGFloat = 25 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func updateShadowColor() {
        self.layer.shadowColor = shadowColor.cgColor
    }
    
    func updateShadowOpacity() {
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func updateShadowRadius() {
        self.layer.shadowRadius = shadowRadius
    }
    
    func updateShadowOffset() {
        self.layer.shadowOffset = shadowOffset
    }
}
