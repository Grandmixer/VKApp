//
//  ViewRegimeOpenSegue.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 14.11.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class ViewRegimeOpenSegue: UIStoryboardSegue {
    override func perform() {
        guard let containerView = source.view.superview else { return }
        guard let sourceViewController = source as? PhotoViewController else { return }
        
        let transitionView = UIImageView(image: sourceViewController.photoPreview)
        transitionView.contentMode = .scaleAspectFit
        transitionView.backgroundColor = .black
        if let sourceFrame = sourceViewController.lastClickedFrame {
            transitionView.frame = CGRect(x: sourceFrame.minX, y: sourceFrame.minY + source.view.frame.minY, width: sourceFrame.width, height: sourceFrame.height)
        }

        containerView.addSubview(transitionView)
        
        UIView.animate(withDuration: 0.3, animations: {
            transitionView.frame = self.destination.view.frame
            self.source.navigationController?.navigationBar.alpha = 0.0
            self.source.tabBarController?.tabBar.alpha = 0.0
        }) { finished in
            self.destination.modalPresentationStyle = .overFullScreen
            self.source.present(self.destination, animated: false, completion: {
                transitionView.removeFromSuperview()
            })
        }
    }
}
