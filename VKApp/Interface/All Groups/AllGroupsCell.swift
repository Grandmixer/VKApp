//
//  AllGroupsCell.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupAvatar: UIImageView!
    @IBOutlet weak var groupAvatarContainer: UIView!
    
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.animateAvatar(_:)))
        self.groupAvatarContainer.addGestureRecognizer(gesture)
    }
    
    func config(group: RealmGroup) {
        groupName.text = group.name
        if let url = URL(string: group.photo_50) {
            groupAvatar.load(url: url)
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
        
        self.groupAvatarContainer.layer.add(animation, forKey: nil)
    }
}


