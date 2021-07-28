//
//  FullScreenPhoto.swift
//  UI_Project
//
//  Created by  Shisetsu on 01.01.2021.
//

import UIKit

class FullScreenPhoto: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var userPhoto: UIImage!
    var counts = 1
    var offset:CGFloat = 0
    var photoArray = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        
        self.collectionView!.register(UINib(nibName: "FullScreenPhotoCell", bundle: nil), forCellWithReuseIdentifier: "FullScreenPhotoCell")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension FullScreenPhoto: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenPhotoCell", for: indexPath) as! FullScreenPhotoCell
        let photos = photoArray[indexPath.row]
        imageCache(url: photos.url!) { image in
            cell.fullPhotoView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photoFrame = collectionView.frame
        
        let cellHeight = photoFrame.width
        
        cell.transform = CGAffineTransform(translationX: 0, y: cellHeight)
        cell.alpha = 0
        
        UIView.animate(withDuration: 1) {
            cell.alpha = 1.0
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let photoFrame = collectionView.frame
//
//        let widthFrame = photoFrame.width / CGFloat(counts)
//        let heightFrame = widthFrame
//
//        return CGSize(width: widthFrame, height: heightFrame)
        
        let photoFrame = collectionView.frame
        
        let widthFrame = photoFrame.width / CGFloat(counts)
        let heightFrame = widthFrame
        
        let spacing = CGFloat((counts + 1)) * offset / CGFloat(counts)
        
        return CGSize(width: widthFrame - spacing, height: heightFrame - (offset*2))
    }
}

