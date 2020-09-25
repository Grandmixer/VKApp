//
//  CustomPopAnimator.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 15.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform.identity
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .calculationModePaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                var transform = CGAffineTransform.identity
                transform = transform.rotated(by: -.pi / 2)
                transform = transform.translatedBy(x: source.view.frame.height / 2 - source.view.frame.width / 2, y: source.view.frame.height / 2 + source.view.frame.width / 2)
                source.view.transform = transform
            })
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
