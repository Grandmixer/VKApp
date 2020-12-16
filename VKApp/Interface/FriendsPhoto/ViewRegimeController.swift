//
//  ViewRegimeController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 14.11.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class ViewRegimeController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeControl: LikedIt!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var interactiveAnimator: UIViewPropertyAnimator?
    
    var photos: [RealmPhoto] = []
    var currentPhoto = 0
    
    var fakeImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitViewRegime))
        swipeGestureRecognizer?.direction = .down
        if let swipe = swipeGestureRecognizer {
            self.view.addGestureRecognizer(swipe)
        }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGestureRecognizer?.delegate = self
        if let pan = panGestureRecognizer {
            self.view.addGestureRecognizer(pan)
        }

        loadPhoto()
    }
    
    func loadPhoto() {
        if photos.count != 0 && photos.count > currentPhoto {
            let photo = photos[currentPhoto]
            imageView.loadImageUsingUrlString(urlString: photo.photo)
            if let image = imageView.image {
                let ratio = image.size.width / image.size.height
                let newHeight = imageView.frame.width / ratio
                imageHeight.constant = newHeight
                view.layoutIfNeeded()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer && otherGestureRecognizer == self.swipeGestureRecognizer {
            return true
        }
        return false
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: self.view)
        var multiplier = CGFloat(1.0)
        
        switch recognizer.state {
        case .began:
            if velocity.x > 0 {
                if currentPhoto > 0 {
                    currentPhoto -= 1
                } else {
                    return
                }
                multiplier = CGFloat(1.0)
            } else if velocity.x < 0 {
                if currentPhoto < photos.count-1 {
                    currentPhoto += 1
                } else {
                    return
                }
                multiplier = CGFloat(-1.0)
            } else {
                return
            }
            
            self.fakeImageView.frame = imageView.frame
            self.fakeImageView.image = imageView.image
            self.fakeImageView.contentMode = .scaleAspectFit
            self.view.addSubview(fakeImageView)
            loadPhoto()
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                let offsetX = multiplier * self.imageView.frame.width
                
                self.imageView.frame = self.imageView.frame.offsetBy(dx: offsetX, dy: 0)
                self.fakeImageView.frame = self.fakeImageView.frame.offsetBy(dx: offsetX, dy: 0)
            })
            interactiveAnimator?.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator?.fractionComplete = abs(translation.x) / self.imageView.frame.width
        case .ended:
            interactiveAnimator?.addCompletion({_ in
                self.fakeImageView.removeFromSuperview()
            })
            interactiveAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default: return
        }
    }
    
    @objc func exitViewRegime() {
        self.performSegue(withIdentifier: "idViewRegimeUnwind", sender: self)
    }
}
