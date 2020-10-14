//
//  AllFriendsCell.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllFriendsCell: UITableViewCell {
        
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendAvatarContainer: UIView!
    @IBOutlet weak var friendAvatar: UIImageView!
    
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.animateAvatar(_:)))
        self.friendAvatarContainer.addGestureRecognizer(gesture)
    }
    
    func config(friend: User) {
        friendName.text = friend.name
        if let url = URL(string: friend.photo_50) {
            friendAvatar.load(url: url)
        }
    }
    
    @objc
    func animateAvatar(_ sender: UITapGestureRecognizer) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.7
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 4
        animation.duration = 0.25
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.friendAvatarContainer.layer.add(animation, forKey: nil)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
