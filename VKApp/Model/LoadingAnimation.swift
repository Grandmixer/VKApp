//
//  LoadingAnimation.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 13.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

@IBDesignable class Loading: UIControl {
    
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
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
            self.view1.alpha = 0.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.view2.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                    self.view3.alpha = 0.0
                }, completion: { _ in
                    UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
                        self.view1.alpha = 1.0
                        self.view2.alpha = 1.0
                        self.view3.alpha = 1.0
                    })
                })
            })
        })
    }
    
    func setupViews(rect: CGRect) {
        
        addSubview(view1)
        view1.frame = bounds.offsetBy(dx: 0, dy: 0)
        view1.backgroundColor = .red
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width / 3.5, height: rect.width / 3.5)).cgPath
        view1.layer.mask = maskLayer1
        
        addSubview(view2)
        view2.frame = bounds
        view2.backgroundColor = .red
        
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = UIBezierPath(ovalIn: CGRect(x: rect.width / 3, y: 0, width: rect.width / 3.5, height: rect.width / 3.5)).cgPath
        view2.layer.mask = maskLayer2
        
        addSubview(view3)
        view3.frame = bounds
        view3.backgroundColor = .red
        
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = UIBezierPath(ovalIn: CGRect(x: rect.width * 2 / 3, y: 0, width: rect.width / 3.5, height: rect.width / 3.5)).cgPath
        view3.layer.mask = maskLayer3
    }
    
}
