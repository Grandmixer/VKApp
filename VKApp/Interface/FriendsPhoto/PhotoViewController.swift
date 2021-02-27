//
//  PhotoViewController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 05.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoViewController: UIViewController {
    
    var photosService = PhotosService()
    var realmService = RealmService()
    var photoService: ImageLoadService?
    
    var photos: Results<RealmPhoto>?
    var token: NotificationToken?
    
    var user: RealmUser?
    
    var lastClickedFrame: CGRect?
    var lastClickedPhoto: Int = 0
    var photoPreview: UIImage?
    
    private let itemsPerRow: CGFloat = 3
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoService = ImageLoadService(container: collectionView)
        
        photosService.loadPhotosList(id: user?.id ?? -1, completion: { [weak self] result in
            //Парсим в объект Realm
            var rPhotos = [RealmPhoto]()
            for photo in result.response.items {
                let rPhoto = RealmPhoto(id: photo.id, text: photo.text, photo: photo.sizes[2].url, user_likes: photo.likes.user_likes, likesCount: photo.likes.count)
                rPhotos.append(rPhoto)
            }
            //Сохраняем объекты в базу данных
            self?.realmService.savePhotoData(rPhotos)
        })
        
        if user?.name == "DELETED" {
            //Парсим в объект Realm
            var rPhotos = [RealmPhoto]()
            
            let rPhoto = RealmPhoto(id: 0, text: "", photo: "https://vk.com/images/deactivated_200.png", user_likes: 0, likesCount: 0)
            rPhotos.append(rPhoto)
            
            //Сохраняем объекты в базу данных
            self.realmService.savePhotoData(rPhotos)
        }
        
        notifyOnRealmChanged()
    }
    
    func notifyOnRealmChanged() {
        guard let realm = try? Realm() else { return }
        
        photos = realm.objects(RealmPhoto.self)
        
        token = photos?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update:
                collectionView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        token?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewRegime") {
            if let vc = segue.destination as? ViewRegimeController {
                if let photos = self.photos {
                    let array = Array(photos)
                    vc.photos = array
                    vc.currentPhoto = lastClickedPhoto
                }
            }
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Получаем ячейку из пула
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell {
            //Получаем объект фотографии для конкретной ячейки
            if let photos = photos {
                let array = Array(photos)
                //cell.config(photo: array[indexPath.item])
                cell.imageView.image = nil
                cell.imageView.image = photoService?.photo(atIndexPath: indexPath, byUrl: array[indexPath.item].photo)
            }
            return cell
        } else {
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        lastClickedFrame = attributes?.frame
        lastClickedPhoto = indexPath.item
        
        if let cellView = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            photoPreview = cellView.imageView.image
        }
        
        performSegue(withIdentifier: "ViewRegime", sender: self)
    }
    
    @IBAction func ReturnFromViewRegime(sender: UIStoryboardSegue) {
        
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * (itemsPerRow - 1))
            
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(itemsPerRow))
            
            return CGSize(width: size, height: size)
        } else {
            fatalError()
        }
    }
}


