//
//  PhotosViewController.swift
//  Photorama
//
//  Created by David on 1/22/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    var photoDataSource: PhotoDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            switch photosResult {
            case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos")
                    OperationQueue.main.addOperation({
                        self.photoDataSource.photos = photos
                        self.collectionView.reloadSections(IndexSet.init(integer: 0))
                    })
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        store.fetchUIImageFromPhotoData(photo: photo, completion: {
            (imageResult) -> Void in
            switch (imageResult) {
            case let .Success(image):
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(image: image)
                }
            case let .Failure(error):
                print("Failed to download imageData for photo: \(photo.getTitle()); Error is: \(error)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photoDataSource.photos[selectedIndexPath.row]
                destinationVC.store = store
            }
        }
    }
}
