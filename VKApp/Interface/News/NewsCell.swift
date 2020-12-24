//
//  NewsCell.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 11.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsAvatar: UIImageView!
    @IBOutlet weak var newsAvatarContainer: UIView!
    @IBOutlet weak var newsNameLabel: UILabel!
    @IBOutlet weak var newsPostingDateLabel: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var likeControl: LikedIt!
    
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.animateAvatar(_:)))
        self.newsAvatarContainer.addGestureRecognizer(gesture)
    }
    
    func config(news: News, name: String, photo_50: String) {
        newsAvatar.image = nil
        newsNameLabel.text = ""
        newsPostingDateLabel.text = ""
        newsText.text = ""
        
        newsText.text = news.text
        
        let date = Date(timeIntervalSince1970: news.date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        dateFormatter.locale = NSLocale.current
        newsPostingDateLabel.text = dateFormatter.string(from: date)
        
        newsNameLabel.text = name
        newsAvatar.loadImageUsingUrlString(urlString: photo_50)
        
        likeControl.likesCount = news.likes.count
        likeControl.isLiked = (news.likes.user_likes == 1)
    }
    
    func config(news: News, user: RealmUser) {
        config(news: news, name: user.name, photo_50: user.photo_50)
    }
    
    func config(news: News, group: RealmGroup) {
        config(news: news, name: group.name, photo_50: group.photo_50)
    }
    
    override func prepareForReuse() {
        newsAvatar.image = nil
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
        
        self.newsAvatarContainer.layer.add(animation, forKey: nil)
    }
}
