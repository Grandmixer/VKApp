//
//  PhotoCell.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 14.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func config(photo: RealmPhoto) {
        imageView.image = nil
        imageView.loadImageUsingUrlString(urlString: photo.photo)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
