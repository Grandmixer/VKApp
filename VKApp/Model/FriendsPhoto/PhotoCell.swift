//
//  PhotoCell.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 14.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoContainer: UIView!
    @IBOutlet weak var photo: UIImageView!
    
    var photos = [UIImage(named: "Avatar"),
                  UIImage(named: "GroupAvatar")]
    var currentPhoto: Int = 0
    var interactiveAnimator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        photo.image = photos[currentPhoto]
        photo.isUserInteractionEnabled = true
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        photo.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        photo.addGestureRecognizer(swipeRight)
    }
    
    @objc
    func handleSwipe(_ recognizer: UISwipeGestureRecognizer) {
        
        if recognizer.direction == .left {
            if currentPhoto > 0 {
                currentPhoto -= 1
                
                if let image = photos[currentPhoto] {
                    swipeAnimation(recognizer, self.frame.width, image)
                }
            }
        } else if recognizer.direction == .right {
            if currentPhoto < photos.count - 1 {
                currentPhoto += 1
                
                if let image = photos[currentPhoto] {
                    swipeAnimation(recognizer, -self.frame.width, image)
                }
            }
        }
    }
    
    func swipeAnimation(_ recognizer: UISwipeGestureRecognizer, _ offset: CGFloat, _ image: UIImage) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.photo.frame = self.photo.frame.offsetBy(dx: -offset, dy: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.0, animations: {
                self.photo.frame = self.photo.frame.offsetBy(dx: 2 * offset, dy: 0)
            })
        }, completion: { _ in
            self.photo.image = image
            UIView.animate(withDuration: 0.25, animations: {
                self.photo.frame = self.photo.frame.offsetBy(dx: -offset, dy: 0)
            })
        })
    }
}
