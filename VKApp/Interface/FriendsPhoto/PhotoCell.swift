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
    @IBOutlet weak var likePhotoControl: LikedIt!
    weak var viewController: UIViewController?
    
    var currentPhoto: Int = 0 {
        didSet {
            /*if let photoController = viewController as? PhotoViewController {
                likePhotoControl.likesCount = photoController.gallery[currentPhoto].likesCount
                likePhotoControl.isLiked = photoController.gallery[currentPhoto].isUserLiked
            }*/
        }
    }
    var interactiveAnimator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        photo.isUserInteractionEnabled = true
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        photo.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        photo.addGestureRecognizer(swipeRight)
    }
    
    func config(parentController: UIViewController) {
        /*if let photoController = parentController as? PhotoViewController {
            photo.image = photoController.gallery[currentPhoto].image
            likePhotoControl.likesCount = photoController.gallery[currentPhoto].likesCount
            likePhotoControl.isLiked = photoController.gallery[currentPhoto].isUserLiked
            likePhotoControl.addTarget(self, action: #selector(self.onLike(_:)), for: .valueChanged)
        }*/
        
        self.viewController = parentController
    }
    
    @objc
    func onLike(_ sender: UIControl) {
        /*guard let photoController = viewController as? PhotoViewController else { return }
        
        photoController.gallery[currentPhoto].likesCount = likePhotoControl.likesCount
        photoController.gallery[currentPhoto].isUserLiked = likePhotoControl.isLiked*/
    }
    
    @objc
    func handleSwipe(_ recognizer: UISwipeGestureRecognizer) {
        /*guard let photoController = viewController as? PhotoViewController else { return }
        if recognizer.direction == .right {
            if currentPhoto > 0 {
                currentPhoto -= 1
                
                if let image = photoController.gallery[currentPhoto].image {
                    swipeAnimation(recognizer, -self.frame.width, image)
                }
            }
        } else if recognizer.direction == .left {
            if currentPhoto < photoController.gallery.count - 1 {
                currentPhoto += 1

                if let image = photoController.gallery[currentPhoto].image {
                    swipeAnimation(recognizer, self.frame.width, image)
                }
            }
        }*/
    }
    
    func swipeAnimation(_ recognizer: UISwipeGestureRecognizer, _ offset: CGFloat, _ image: UIImage) {
        self.superview?.layoutIfNeeded()
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
