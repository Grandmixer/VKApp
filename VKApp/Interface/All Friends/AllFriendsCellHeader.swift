//
//  AllFriendsCellHeader.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 07.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllFriendsCellHeader: UITableViewHeaderFooterView {
    
    var headerTitle = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initializeContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initializeContents()
    }
    
    func initializeContents() {
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(headerTitle)
        
        NSLayoutConstraint.activate([
            headerTitle.heightAnchor.constraint(equalToConstant: 30),
            headerTitle.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            headerTitle.trailingAnchor.constraint(equalTo:
                   contentView.layoutMarginsGuide.trailingAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        headerTitle.textAlignment = NSTextAlignment.left
    }
    
    func config(sectionItem: FriendsCellHeaderItem) {
        headerTitle.text = sectionItem.headerTitle
        headerTitle.textColor = UIColor(red: CGFloat(237 / 255.0), green: CGFloat(246 / 255.0), blue: CGFloat(246 / 255.0), alpha: 1.0)
        contentView.backgroundColor = UIColor(red: CGFloat(74 / 255.0), green: CGFloat(118 / 255.0), blue: CGFloat(168 / 255.0), alpha: 1.0)
    }
}
