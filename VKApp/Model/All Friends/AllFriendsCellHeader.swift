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
    
    func config(title: String, color: UIColor) {
        headerTitle.text = title
        contentView.backgroundColor = color
    }
}
