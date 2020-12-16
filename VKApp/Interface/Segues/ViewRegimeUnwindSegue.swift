//
//  ViewRegimeUnwindSegue.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 29.11.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class ViewRegimeUnwindSegue: UIStoryboardSegue {
    override func perform() {
        guard let containerView = source.view.superview else { return }
        guard let sourceViewController = source as? ViewRegimeController else { return }
        guard let destinationViewController = destination as? PhotoViewController else { return }
        
        let transitionView = UIImageView(image: sourceViewController.imageView.image)
        transitionView.contentMode = .scaleAspectFit
        transitionView.backgroundColor = .black
        transitionView.frame = source.view.frame

        containerView.addSubview(transitionView)
        source.view.isHidden = true
        
        guard let destinationFrame = destinationViewController.lastClickedFrame else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            transitionView.frame = CGRect(x: destinationFrame.minX, y: destinationFrame.minY + self.destination.view.frame.minY, width: destinationFrame.width, height: destinationFrame.height)
            self.destination.navigationController?.navigationBar.alpha = 1.0
            self.destination.tabBarController?.tabBar.alpha = 1.0
        }) { finished in
            transitionView.removeFromSuperview()
            self.source.dismiss(animated: false, completion: nil)
        }
    }
}
