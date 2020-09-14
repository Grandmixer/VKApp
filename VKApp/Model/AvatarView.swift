//
//  AvatarView.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 04.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

@IBDesignable class AvatarView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn: CGRect(x: rect.midX - maskRadius, y: rect.midY - maskRadius, width: maskRadius * 2, height: maskRadius * 2)).cgPath
        self.layer.mask = maskLayer
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    @IBInspectable var maskRadius: CGFloat = 25.0 {
        didSet {
            setNeedsDisplay()
        }
    }
}
