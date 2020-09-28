//
//  LikedIt.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 04.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

@IBDesignable class LikedIt: UIControl {
    
    var isLiked: Bool = false {
        didSet {
            button.isSelected = isLiked
            button.tintColor = button.isSelected ? .red : .systemBlue
            self.sendActions(for: .valueChanged)
        }
    }
    var likesCount: Int = 0 {
        didSet {
            UIView.transition(with: button, duration: 0.25, options: .transitionFlipFromLeft, animations: {
                self.button.setTitle(String(self.likesCount), for: .normal)
            })
        }
    }
    
    private var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    private func setupView() {
        button = UIButton(type: .custom)
        
        button.setTitle(String(likesCount), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.setImage(UIImage(systemName: "suit.heart.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        
        button.addTarget(self, action: #selector(likePhoto(_ :)), for: .touchUpInside)

        self.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    @objc private func likePhoto(_ sender: UIButton) {
        if !sender.isSelected {
            self.likesCount += 1
            self.isLiked = true
        } else {
            self.likesCount -= 1
            self.isLiked = false 
        }
    }
}
