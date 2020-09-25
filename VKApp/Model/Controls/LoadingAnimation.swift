//
//  LoadingAnimation.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 13.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

@IBDesignable class Loading: UIControl {
    
    let dot1View = UIView()
    let dot2View = UIView()
    let dot3View = UIView()
    weak var timer: Timer?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupViews(rect: rect)
        self.startTimer()
        self.timer?.fire()
        
        //animateDotsOnce()

    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.75, repeats: true) { _ in
            self.animateDotsOnce()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func animateDotsOnce() {
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.dot1View.alpha = 0.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.dot2View.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                    self.dot3View.alpha = 0.0
                }, completion: { _ in
                    UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
                        self.dot1View.alpha = 1.0
                        self.dot2View.alpha = 1.0
                        self.dot3View.alpha = 1.0
                    })
                })
            })
        })
    }
    
    func setupViews(rect: CGRect) {
        
        addSubview(dot1View)
        dot1View.frame = bounds
        dot1View.backgroundColor = .red
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width / 3.5, height: rect.width / 3.5)).cgPath
        dot1View.layer.mask = maskLayer1
        
        addSubview(dot2View)
        dot2View.frame = bounds
        dot2View.backgroundColor = .red
        
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = UIBezierPath(ovalIn: CGRect(x: rect.width / 3, y: 0, width: rect.width / 3.5, height: rect.width / 3.5)).cgPath
        dot2View.layer.mask = maskLayer2
        
        addSubview(dot3View)
        dot3View.frame = bounds
        dot3View.backgroundColor = .red
        
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = UIBezierPath(ovalIn: CGRect(x: rect.width * 2 / 3, y: 0, width: rect.width / 3.5, height: rect.width / 3.5)).cgPath
        dot3View.layer.mask = maskLayer3
    }
    
}
