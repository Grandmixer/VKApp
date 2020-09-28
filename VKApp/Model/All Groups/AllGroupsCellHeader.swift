//
//  AllGroupsCellHeader.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 21.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllGroupsCellHeader: UITableViewHeaderFooterView {
    
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
            headerTitle.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        headerTitle.textAlignment = NSTextAlignment.left
    }
    
    func config(sectionItem: GroupsCellHeaderItem) {
        headerTitle.text = sectionItem.headerTitle
        contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
}
