//
//  CustomPushAnimator.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 15.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //Получаем текущий и следующий view controller
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        //Добавляем следующий view controller в контейнер и задаем начальные frame и transform
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -.pi / 2)
        transform = transform.translatedBy(x: source.view.frame.height / 2 - source.view.frame.width / 2, y: source.view.frame.height / 2 + source.view.frame.width / 2)
        destination.view.transform = transform
        
        //Добавляем этапы анимации
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .calculationModePaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    destination.view.transform = .identity
                })
    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
    
}
