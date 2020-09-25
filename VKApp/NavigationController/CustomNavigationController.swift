//
//  File.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 15.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactivetransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactivetransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactivetransition.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivetransition.hasStarted ? interactivetransition : nil
    }
}
