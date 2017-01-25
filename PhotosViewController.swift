//
//  PhotosViewController.swift
//  Photorama
//
//  Created by David on 1/22/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            switch photosResult {
            case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos")
                    if let firstPhoto = photos.first {
                        self.store.fetchUIImageFromPhotoData(photo: firstPhoto) {
                            (imageResult) -> Void in
                            switch imageResult {
                            case let .Success(image):
                                    print("Successfully downloaded image for photo: \(firstPhoto.getTitle())")
                                    OperationQueue.main.addOperation({
                                        self.imageView.image = image
                                    })
                            case let .Failure(error):
                                print("Failed to download image for photo: \(firstPhoto.getTitle()); Error is: \(error)")
                            }
                        }
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
