//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by David on 1/25/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.getTitle()
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = photo.getImage() {
            imageView.image = image
            return
        }
        store.fetchUIImageFromPhotoData(photo: photo, completion: {
            (imageResult) -> Void in
            switch imageResult {
            case let .Success(image):
                OperationQueue.main.addOperation({
                    self.imageView.image = image
                })
            case let .Failure(error):
                print("Error fetching image for photo: \(error)")
            }
        })
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
