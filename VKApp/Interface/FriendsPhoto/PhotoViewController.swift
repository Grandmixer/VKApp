//
//  PhotoViewController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 05.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    var photos = [Photo]()
    var photosService = PhotosService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosService.loadPhotosList(completion: { [weak self] result in
            self?.photos = result.response.items
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            performSegue(withIdentifier: "ExitFromPhoto", sender: self)
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell {
            //cell.config(parentController: self)
            
            return cell
        } else { fatalError() }
    }
}


