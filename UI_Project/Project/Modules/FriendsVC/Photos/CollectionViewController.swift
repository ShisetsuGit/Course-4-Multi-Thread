//
//  CollectionViewController.swift
//  UI_Project
//
//  Created by  Shisetsu on 12.12.2020.
//

import UIKit
import RealmSwift

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var token: NotificationToken?

    var photoToFullScreen: Results<PhotoModel>?{
        didSet {
            token = photoToFullScreen!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let collectionView = self?.collectionView else { return }
                switch changes {
                case .initial:
                    print("INITIAL")
                case .update:
                    collectionView.reloadData()
                case .error(let error):
                    print("ERROR")
                    fatalError("\(error)")
                }
            }
        }
    }
    let DB = PhotoDatabaseService()
    var userID = String()
    
    var counts = 3
    var offset:CGFloat = 2.0
    
    
    override func viewDidLoad() {
        photoToFullScreen = DB.readResults(userID: userID)
        
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "friendPhoto")
        self.collectionView!.register(UINib(nibName: "PhotoFullViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoFullViewCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photos = photoToFullScreen![indexPath.row]
        imageCache(url: photos.url!) { image in
            let imageView = UIImageView(image: image)
            imageView.frame = self.view.frame
            imageView.backgroundColor = .black
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
            imageView.addGestureRecognizer(tap)

            self.view.addSubview(imageView)
            self.tabBarController?.tabBar.isHidden = true
            collectionView.isScrollEnabled = true
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoToFullScreen!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFullViewCell", for: indexPath) as! PhotoFullViewCell
        let photos = photoToFullScreen![indexPath.row]
        imageCache(url: photos.url!) { image in
            cell.photoView.image = image
            cell.photoView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photoFrame = collectionView.frame
        let widthFrame = photoFrame.width / CGFloat(counts)
        let heightFrame = widthFrame
        let spacing = CGFloat((counts + 1)) * offset / CGFloat(counts)
        return CGSize(width: widthFrame - spacing, height: heightFrame - (offset*2))
    }

}
